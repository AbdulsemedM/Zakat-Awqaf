# Zakat section — backend APIs needed by the mobile app

The Mejlis Digital Hub mobile app still shows hard-coded, seeded or simulated data in most of the **Zakat** section. This document lists the APIs the app needs so that every number, list and status comes from the backend, and **no dummy data is ever shown**. Awqaf is out of scope.

- Part A lists the APIs that already exist and work.
- Part B lists the new or changed APIs, one per screen.
- Part C is a suggested delivery order.

## Conventions

These match `FRONTEND-API-GUIDE.md`.

- **Base path.** Everything goes through the gateway: `{{baseUrl}}/api/<service>/v1/...`. The service names used below (`zakat`, `payments`, `content`, `beneficiaries`) are suggestions. Please tell us the final ones.
- **Envelope.**
  - Success: `{ "success": true, "data": …, "message": "…" }`
  - Error: `{ "success": false, "message": "…", "errors": [{ "field", "message" }] }`
- **Pagination.**
  - Request: `?page=1&limit=20`.
  - Response: `{ "items": [...], "pagination": { "page", "limit", "totalItems", "totalPages" } }`.
- **Values.**
  - Money is **ETB** as a decimal number.
  - Dates are `YYYY-MM-DD`. Timestamps are ISO-8601 with an offset.
  - Ids are strings.
  - Option values are lowercase keys.
- **Translated content.** Endpoints that return display text (titles, descriptions, stories, hadith) must accept `?lang=en|am|ar|om|so`, or read the `Accept-Language` header. They return the text in that language and fall back to English.
- **Images.** Return an absolute `imageUrl`, not a file name. The app shows a placeholder when it is `null`.
- **Auth.**
  - "Public" means no token is needed (guests can open the home and calculator screens).
  - "Auth" means `Authorization: Bearer <token>` for a logged-in donor or beneficiary.
- **Empty is not an error.** When there is nothing to show (no causes, no history), return `200` with an empty list or `null` values. The app will show an empty state instead of placeholder figures.

---

## Part A — Already live (no change needed)

| Method | Path | Used for |
|---|---|---|
| POST | `/api/auth/v1/login` | Sign-in |
| POST | `/api/beneficiaries/v1/registration-codes/validate` | Check a registration code and show its branch |
| POST | `/api/beneficiaries/v1/beneficiaries` | Beneficiary registration (manual multipart, or Fayda `{registrationCode, nationalId}`) |
| GET | `/api/beneficiaries/v1/sse/beneficiary/{id}` | Fayda verification events |
| POST | `/api/beneficiaries/v1/accounts/set-password` | First password |
| POST | `/api/beneficiaries/v1/companies`, `/companies/{id}/documents` | Institution registration and KYC upload |
| GET | `/api/beneficiaries/v1/me` | Beneficiary profile |
| PUT | `/api/beneficiaries/v1/me/bank-account` | Payout bank account |
| GET | `/api/beneficiaries/v1/me/application` | Application status. **Please publish the response shape.** The app currently guesses `status`, `branchName`, `submittedAt` and `message` |
| POST | `/api/payments/v1/donations` | International Sadaqah. Returns the hosted payment URL |

The app also calls one external service, `https://fxapi.app/api/USD/ETB.json`, for the USD→ETB rate. B2.1 replaces it.

---

## Part B — New or changed APIs

### B1. Home screen

#### B1.1 `GET /api/zakat/v1/home/summary` — Public

**Replaces** these hard-coded figures:
- "ETB 1.12M this month"
- "↑ Growing strong"
- "4,982 beneficiaries"
- the "LIVE · ETB 12,842,300 collected" pill

**Response `data`:**
```json
{
  "totalCollectedEtb": 12842300.00,
  "currentMonth": {
    "collectedEtb": 1120000.00,
    "previousMonthCollectedEtb": 980000.00,
    "changePercent": 14.3
  },
  "totalBeneficiariesSupported": 4982,
  "asOf": "2026-09-30T08:00:00+03:00"
}
```

**Notes:**
- The app builds the trend text from `changePercent`. It shows no badge when `changePercent` is `null`.
- A cache of a few minutes is fine. The "LIVE" label is shown only when `asOf` is less than 1 hour old.

#### B1.2 `GET /api/zakat/v1/causes?status=active&urgent=true&page&limit` — Public

**Replaces** the constant `homeUrgentNeeds` list ("Education Support", "Clean Water"). The same data feeds the **beneficiary project dropdown** on the payment screen (B3.2).

**Item:**
```json
{
  "id": "12",
  "title": "Education Support",
  "description": "School fees and materials for orphans in Harar",
  "category": "education",
  "badge": "urgent",
  "imageUrl": "https://…/causes/12.jpg",
  "goalEtb": 500000.00,
  "raisedEtb": 325000.00,
  "progress": 0.65,
  "region": "Harari",
  "endsOn": "2026-12-31",
  "acceptsZakat": true
}
```

**Field notes:**
- `category` is one of `education`, `water`, `health`, `food`, `shelter`, `livelihood`, `emergency` or `general`. The app maps it to an icon and colour, so no colours or icons should be sent.
- `badge` is one of `essential`, `urgent` or `null`.

Also needed:
- `GET /api/zakat/v1/causes/{id}` returns the same item plus a long-form `body` and `images[]`. It backs the "View all" screen and a cause detail screen, which today go nowhere.

#### B1.3 `GET /api/zakat/v1/zakat-al-fitr/current` — Public

**Replaces:**
- the static "UPCOMING" badge;
- the static "due in N days" text.

**Response `data`:**
```json
{
  "hijriYear": 1448,
  "status": "upcoming",
  "startsOn": "2027-03-01",
  "dueBy": "2027-03-09",
  "perPersonAmountEtb": 150.00,
  "basis": "Price of one sa' of staple food, set by the commission"
}
```

**Notes:**
- `status` is one of `upcoming`, `open` or `closed`.
- The app computes the days remaining itself.
- "Pay Zakat al-Fitr" pre-fills `perPersonAmountEtb × household size` into B3.3 with `zakatType: "fitr"`.

#### B1.4 (Optional) `POST /api/zakat/v1/reminders` — Auth

**Why:** the "Set reminder" button currently does nothing.

**Body:**
```json
{ "type": "zakat_al_fitr", "channel": "push" }
```

**Push notifications.** This needs a device-token endpoint as well:
- `POST /api/notifications/v1/devices`, body `{ token, platform }`.

The same device endpoint is needed for the profile's **Nisab alerts** toggle (B5.5).

---

### B2. Zakat calculator

#### B2.1 `GET /api/zakat/v1/calculator/config` — Public

**Replaces:**
- the seeded gold price payload (`SeededGoldPriceRepository`);
- the external FX API and its hard-coded fallback rate (`156.183869`);
- the hard-coded silver price (`50 ETB/g`);
- the default nisab (`354,025 ETB`);
- every rate and threshold in the code.

This one endpoint makes the whole calculator dynamic.

**Response `data`:**
```json
{
  "configVersion": 3,
  "pricesAsOf": "2026-09-30T06:00:00+03:00",
  "priceSource": "LBMA via <provider>",
  "usdEtbRate": 156.18,
  "goldPricePerGramEtb": { "24k": 22984.10, "22k": 21068.70, "21k": 20111.10, "18k": 17238.10, "14k": 13407.40 },
  "silverPricePerGramEtb": 285.40,
  "nisab": {
    "basis": "gold",
    "goldGrams": 85,
    "silverGrams": 595,
    "valueEtb": 1953648.50
  },
  "wealth": { "rate": 0.025, "hawlLunarDays": 354 },
  "crops": { "nisabKg": 653, "rainFedRate": 0.10, "irrigatedRate": 0.05 },
  "livestock": {
    "sheepGoats": [
      { "min": 40,  "max": 120, "due": "1 sheep" },
      { "min": 121, "max": 200, "due": "2 sheep" },
      { "min": 201, "max": 300, "due": "3 sheep" },
      { "min": 301, "max": null, "due": "1 sheep per 100", "perHundred": 1 }
    ],
    "cattle": { "minimum": 30, "tabiPer": 30, "musinnahPer": 40 },
    "camels": [
      { "min": 5, "max": 9, "due": "1 sheep" },
      { "min": 25, "max": 35, "due": "1 bint makhad" }
    ]
  },
  "livestockAverageUnitPriceEtb": { "sheep": 9000, "goat": 7000, "cattle": 60000, "camel": 180000 }
}
```

**Notes:**
- **The app will stop computing gold in ETB.** It currently multiplies a USD gold price by the FX rate. The backend should return ETB prices directly.
- **`nisab.basis`.** It is `gold` or `silver`: the commission chooses which metal sets nisab. `valueEtb` is precomputed so every client agrees.
- **Livestock tables.** They are fully data-driven, so a scholar or committee decision can change them without an app release.
  - The camel table above is shortened. Please return all tiers.
  - Translated `due` labels follow the `lang` rule.
- **`livestockAverageUnitPriceEtb`.** This powers the "market estimate" ETB amount on livestock certificates. Today it is guessed on the device.
- **Refresh and no-data behaviour.** Refresh at least daily. If prices are older than 48 hours, the app shows "prices may be out of date". It **never** falls back to built-in numbers; if the call fails, the calculator shows a retry state.

#### B2.2 (Optional) `POST /api/zakat/v1/calculator/calculate` — Public

This lets the server calculate the zakat due, so the app and a future web calculator give exactly the same result.

**Body:**
```json
{
  "type": "wealth",
  "wealth": { "cashEtb": 0, "bankEtb": 0, "goldGrams": { "24k": 0 }, "silverGrams": 0, "businessAssetsEtb": 0, "receivablesEtb": 0, "debtsEtb": 0 }
}
```
- `type` is one of `wealth`, `livestock` or `crops`.
- For the other types, send `livestock: { sheep, goats, cattle, camels }` or `crops: { kg, irrigation: rain_fed|irrigated|mixed, rainFedShare }`.

**Response:**
```json
{ "zakatableEtb", "nisabEtb", "meetsNisab", "zakatDueEtb", "dueInKind": [ { "item", "quantity" } ], "configVersion" }
```

When this endpoint exists, the app sends `configVersion` along with the payment.

---

### B3. Zakat payment and certificate

**Today this whole flow is simulated.** The app waits 450 ms, makes up a certificate id `ZK-<timestamp>`, and builds the PDF on the device. No money moves. These APIs replace all of that.

#### B3.1 `GET /api/payments/v1/methods?purpose=zakat` — Public

**Replaces** the hard-coded enum of checkout methods (Coop Bank Alhuda, telebirr, CBE Birr, M-Pesa, CBE, Zamzam).

**Item:**
```json
{
  "code": "coopbank_alhuda",
  "label": "Coop Bank Alhuda",
  "subtitle": "Interest-free Islamic banking",
  "type": "bank",
  "logoUrl": "https://…/methods/coopbank.png",
  "available": true,
  "unavailableReason": null,
  "minAmountEtb": 10,
  "maxAmountEtb": 1000000,
  "flow": "redirect"
}
```

**Field notes:**
- `type` is one of `bank`, `wallet` or `card`.
- `flow` is `redirect` (a hosted page opened in a WebView, as donations do today) or `ussd_push` (the user approves on their phone).
- When `available` is `false`, the method is shown greyed out with its `unavailableReason`.

#### B3.2 Beneficiary projects

**Replaces** the project dropdown, which today lists the home cause titles plus "General Zakat fund" and sends the title string.

- Reuse `GET /api/zakat/v1/causes?acceptsZakat=true`.
- Add a permanent item with `id: "general"` for the general fund.
- The payment then sends the `causeId`.

#### B3.3 `POST /api/payments/v1/zakat-payments` — Auth (guest allowed, see below)

This creates a payment intent.

**Body:**
```json
{
  "zakatType": "wealth",
  "amountEtb": 12500.00,
  "methodCode": "coopbank_alhuda",
  "causeId": "general",
  "payer": { "fullName": "Amina Hassen", "phone": "+251911223344", "email": null, "anonymous": false },
  "calculation": {
    "configVersion": 3,
    "zakatableEtb": 500000.00,
    "nisabEtb": 1953648.50,
    "naturalUnitSummary": "2 sheep",
    "amountIsMarketEstimate": false
  },
  "recurring": { "enabled": true, "interval": "monthly", "dayOfMonth": 1 },
  "idempotencyKey": "b1e0…uuid"
}
```

**Body notes:**
- `zakatType` is one of `wealth`, `livestock`, `crops`, `fitr` or `general`.
- `calculation` is optional. It is sent when the amount came from the calculator.
- **Guests.** Allow a guest payment when `payer.phone` is given. Link it to the account if the user signs in later with that phone.

**Response `data`:**
```json
{
  "paymentId": "pay_8812",
  "status": "pending",
  "flow": "redirect",
  "redirectUrl": "https://pay…/checkout/…",
  "returnUrlPrefix": "https://app.mejlis…/payments/return",
  "expiresAt": "2026-09-30T10:30:00+03:00"
}
```

**How the app uses it:**
- The app opens `redirectUrl` in a WebView.
- It closes the WebView when the page navigates to a URL starting with `returnUrlPrefix`.

**Recurring:**
- This replaces the "Save for recurring monthly" switch, which today is stored nowhere.
- Recurring payments need a mandate or scheduled charge on the backend.
- If that is not ready, return `400` on `recurring` and the app will hide the switch.

#### B3.4 `GET /api/payments/v1/zakat-payments/{paymentId}` — Auth or guest token

The app polls this after the WebView closes, every 3 seconds for up to 2 minutes. A webhook-driven SSE stream, like the beneficiary one, is fine too.

**Response `data`:**
```json
{
  "paymentId": "pay_8812",
  "status": "succeeded",
  "amountEtb": 12500.00,
  "methodLabel": "Coop Bank Alhuda",
  "providerReference": "FT2627312345",
  "paidAt": "2026-09-30T10:14:22+03:00",
  "failureReason": null,
  "certificateId": "ZC-2026-000451"
}
```

`status` is one of `pending`, `succeeded`, `failed`, `cancelled` or `expired`.

#### B3.5 Certificates — Auth or guest token

**Replaces** the certificate built on the device, whose id is made up and which has no way to be verified.

| Method | Path | Returns |
|---|---|---|
| GET | `/api/payments/v1/certificates/{certificateId}` | Certificate data: `{ certificateId, payerFullName, amountEtb, zakatType, causeTitle, naturalUnitSummary, methodLabel, providerReference, paidAt, issuedAt, hijriDate, issuer: { name, logoUrl, signatoryName, signatoryTitle, signatureUrl }, verificationUrl }` |
| GET | `/api/payments/v1/certificates/{certificateId}/pdf` | The official PDF (`application/pdf`) |
| GET | `/api/payments/v1/certificates/verify/{certificateId}` (Public) | `{ valid, payerName (masked), amountEtb, paidAt }`. It is the target of the QR code on the certificate |

The app will download and share the server PDF. If the design should stay on the device, the app will instead draw the PDF from the `GET` data and add a QR code for `verificationUrl`.

#### B3.6 Local Sadaqah

**Why:** the "local" Sadaqah option currently goes into the same simulated screen.

- Use the same B3.3 endpoint with `zakatType: "general"` and a new field `purpose: "sadaqah"`.
- Alternatively, extend `POST /api/payments/v1/donations` with the local payment methods.

Please say which one you prefer.

---

### B4. Impact screen

**Replaces:** everything on this screen. `MockImpactDataProvider` is the one wired in, and it returns:
- the headline figures: ETB 42.55M distributed, 142,500 lives touched, 84 projects;
- 4 fixed cities on the map;
- 3 made-up stories ("Ahmed's Shop", "Sara's Degree", "Zubeida's Clinic").

#### B4.1 `GET /api/zakat/v1/impact/summary?region=` — Public

```json
{
  "scope": "national",
  "regionName": "Ethiopia",
  "distributedFundsEtb": 42550000.00,
  "livesTouched": 142500,
  "activeProjects": 84,
  "beneficiariesByAsnaf": [ { "asnaf": "poor", "count": 2100 }, { "asnaf": "debtor", "count": 310 } ],
  "asOf": "2026-09-30T08:00:00+03:00"
}
```
When `region` is omitted, the numbers are national.

#### B4.2 `GET /api/zakat/v1/impact/regions` — Public

This drives the map markers.

```json
[ { "code": "addis_ababa", "name": "Addis Ababa", "latitude": 9.03, "longitude": 38.74,
    "distributedFundsEtb": 12000000.00, "beneficiaries": 40210, "activeProjects": 21 } ]
```

#### B4.3 `GET /api/zakat/v1/impact/stories?page&limit` and `GET …/stories/{id}` — Public

```json
{ "id": "5", "title": "Ahmed's Shop", "summary": "…", "body": "…", "category": "livelihood",
  "region": "Harari", "imageUrl": "https://…", "publishedAt": "2026-08-01" }
```

**Consent:** stories must only be published with the beneficiary's consent. The API should never return beneficiary ids.

---

### B5. Profile (Zakat parts)

#### B5.1 `GET /api/zakat/v1/me/giving-summary` — Auth (donor)

**Replaces:** the stats on the profile's impact dashboard. `totalZakatPaid`, `activeEndowments` and `beneficiariesHelped` are always `0` today because no API fills them. The fixed subtitles ("FY summary", …) are replaced by `period`.

```json
{
  "period": { "label": "1447 AH", "from": "2025-06-27", "to": "2026-06-16" },
  "totalZakatPaidEtb": 124500.00,
  "totalSadaqahEtb": 8000.00,
  "paymentsCount": 9,
  "beneficiariesHelped": 87,
  "causesSupported": 4
}
```

`beneficiariesHelped` can be an estimate: the share of the funds the user gave to beneficiaries.

#### B5.2 `GET /api/payments/v1/me/payments?type=zakat|sadaqah&page&limit` — Auth

**Replaces:** the "Zakat history" and "Donation history" rows, which only show "coming soon".

**Item:**
```json
{ "paymentId": "pay_8812", "type": "zakat", "zakatType": "wealth", "amountEtb": 12500.00,
  "methodLabel": "Coop Bank Alhuda", "causeTitle": "General Zakat fund", "status": "succeeded",
  "paidAt": "2026-09-30T10:14:22+03:00", "certificateId": "ZC-2026-000451" }
```

Tapping a row opens its certificate (B3.5).

#### B5.3 `GET /api/beneficiaries/v1/me/disbursements?page&limit` — Auth (beneficiary)

**Replaces:** "Last disbursement" (always "—") and "Total aid received" (always ETB 0) on the beneficiary card.

```json
{
  "summary": { "totalReceivedEtb": 15000.00, "lastDisbursedAt": "2026-09-12", "nextExpectedAt": "2026-10-12" },
  "items": [ { "id": "d1", "amountEtb": 1500.00, "disbursedAt": "2026-09-12", "method": "Coop Bank",
               "reference": "FT…", "programme": "Monthly support", "status": "paid" } ],
  "pagination": { … }
}
```

**Visibility:** in line with section 7 of the frontend guide, this must not return scores, risk levels or assessment data.

**Alternative:** add `lastDisbursedAt` and `totalReceivedEtb` to `GET /me` and skip the list for now.

#### B5.4 `GET /api/payments/v1/payout-institutions` — Public

**Replaces:** the hard-coded bank list (Hijra, Zamzam, Coop, CBE, TeleBirr), where only Coop is enabled and the rest say "Coming soon".

```json
[ { "code": "coopbank", "label": "Coop Bank", "type": "bank", "logoUrl": "…",
    "available": true, "accountNumberPattern": "^\\d{13}$" } ]
```

`PUT /me/bank-account` should then accept `institutionCode` along with, or instead of, `bankName`.

#### B5.5 `GET` / `PATCH /api/auth/v1/me/preferences` — Auth

**Why:** today madhhab, Nisab alerts, language and theme are kept only in memory and reset when the app restarts.

```json
{ "madhhab": "hanafi", "language": "am", "nisabAlerts": true, "zakatAnniversaryDate": "2026-04-10" }
```

**Notes:**
- `madhhab` is one of `hanafi`, `shafii`, `maliki` or `hanbali`.
- `zakatAnniversaryDate` is the user's hawl date. It makes Nisab alerts and zakat reminders meaningful, and needs the push device endpoint in B1.4.
- Theme can stay on the device.

#### B5.6 `GET /api/content/v1/hadith/today` — Public

**Replaces:** the single hard-coded "Hadith of the day".

```json
{ "date": "2026-09-30", "text": "…", "source": "Sahih Muslim 987", "language": "am" }
```

---

### B6. Beneficiary registration — data the app collects but cannot send

The app collects this data on screen, but no API accepts it, so it is thrown away.

| Collected in the app | Needed | Suggested API |
|---|---|---|
| Needs step: situation description (required) | Store with the application | Add `situationDescription` to `POST /beneficiaries`, or `PATCH /me/application` `{ situationDescription }` |
| Needs step: supporting proof. The upload is **fake** today: it stores a fixed file name and never opens a file picker | Real document upload | `POST /api/beneficiaries/v1/me/documents` (multipart `file`, `documentType`: `medical_report`, `debt_documents`, `disability_certificate`, `school_certificate` or `other`) and `GET /me/documents`. Also allowed right after registration with the `passwordSetupToken`, the way company documents use an upload token |
| Disbursement step: payout method (telebirr / M-Pesa / Coop) and account or mobile number | Save as the payout account | Extend `PUT /me/bank-account` to `{ institutionCode, accountNumber, accountHolderName }`, using B5.4 for the list of institutions |
| Disbursement step: compliance / declaration acceptance and legal name | Store proof of consent | `POST /me/declarations` `{ declarationVersion, acceptedAt, legalName }` |
| Asnaf categories (8, hard-coded with English labels) | Translated list managed by the backend | `GET /api/beneficiaries/v1/options/asnaf?lang=` → `[{ key, label, description }]`. **Optional:** the keys are fixed, and the app can keep its own translations |

---

## Part C — Suggested delivery order

1. **B3: real zakat payment, status and certificates.** Without these, no zakat can actually be paid. This is the highest risk.
2. **B2.1: calculator config.** It removes every seeded price and hard-coded rate.
3. **B6: data dropped during registration** (proof upload and payout account). Applicants currently lose data they typed in.
4. **B1: home summary, causes and Zakat al-Fitr.** The first screen users see should show real figures.
5. **B5: giving summary, payment history, disbursements, payout institutions and preferences.**
6. **B4: impact** (summary, regions and stories).
7. **Optional items:** B1.4 reminders and push notifications, B2.2 server-side calculation, B5.6 hadith, and the asnaf options list.

**Until an API ships:** the app hides that widget or shows an empty or "not available yet" state. It does **not** show sample figures.

## Open questions for the backend team

1. What are the final service names and paths? The `zakat`, `payments` and `content` prefixes above are suggestions.
2. Which payment providers are live for zakat, and which use redirect versus USSD push?
3. Should the certificate PDF be generated on the server (recommended, since it can carry a signature and a QR code) or drawn by the app from the certificate data?
4. Should nisab be based on gold or silver? This is a commission decision.
5. Can guests pay zakat without an account?
6. What is the exact response shape of `GET /me/application`?
