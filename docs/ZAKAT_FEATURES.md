# Zakat Features

Short overview of the **zakat** side of Mejlis Digital Hub (Awqaf excluded).

## Home

- Greeting, live collection highlights, and urgent zakat causes
- CTA to register as a zakat beneficiary
- Entry to give **Sadaqah** (local or international)
- Zakat Al-Fitr reminder card

## Zakat calculator

- Calculate zakat on **wealth** (cash, gold/silver, business assets)
- Calculate zakat on **livestock** (sheep/goats, cattle, camels)
- Calculate zakat on **crops**
- Uses local nisab rules; gold prices are seeded; USD→ETB rate is fetched live
- Continues into the zakat payment flow

## Zakat payment & certificate

- Pay calculated or custom zakat amount
- Choose a checkout method (e.g. Coop Bank Alhuda)
- Optional beneficiary project and recurring option
- Issue a shareable zakat payment certificate (PDF)

> Local payment path is currently simulated (no live payment gateway).

## International donation (Sadaqah)

- Donate internationally with amount, donor details, and address
- Opens a hosted payment page in-app (webview)
- Backed by the live donations API (`paymentPurpose: SADAQAH`)

## Beneficiary registration

Register to receive zakat as:

1. **Individual (Fayda / national ID)** — verify identity, then set password  
2. **Individual (manual)** — submit identity details, then set password  
3. **Institution** — company details, set password, upload KYC documents  

Supports asnaf category, needs, and payout bank details. Registration APIs are live.

## Sign-in & profile

- Sign in with Ethiopian phone (`+251`) and password
- View beneficiary profile and update bank account for disbursements
- Language / app settings; apply or continue registration from profile
- Zakat/donation history is marked coming soon

## Impact

- National zakat impact stats, regional map, and stories
- Currently driven by mock data (refresh available in UI)

## Main navigation

| Tab / screen | Purpose |
|--------------|---------|
| Home | Discover causes, donate, register |
| Calculator | Compute zakat due |
| Impact | See where zakat goes |
| Profile | Sign in / manage beneficiary account |

**Related flows:** beneficiary registration · zakat payment · certificate · international donation
