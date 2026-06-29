"""Generate locale override JSON files from English template strings."""
from __future__ import annotations

import json
import re
import time
from pathlib import Path

from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / 'lib' / 'l10n'
OUT = Path(__file__).resolve().parent / 'l10n_overrides'

LOCALES = {
    'am': 'am',
    'ar': 'ar',
    'om': 'om',  # Oromo — best-effort via Google
    'so': 'so',
}

KEEP_LITERAL = {
    'splashWaqfByTitle',
    'donationAmountHint',
    'calcRelationGte',
    'calcRelationLt',
    'calcBulletSeparator',
    'calcUsdEtb',
    'calcGoldK24',
    'calcGoldK22',
    'calcGoldK21',
    'calcGoldK18',
    'calcGoldK14',
}

PLACEHOLDER_RE = re.compile(r'(\{[^{}]+\})')


def protect_placeholders(text: str) -> tuple[str, list[str]]:
    tokens: list[str] = []

    def repl(match: re.Match[str]) -> str:
        tokens.append(match.group(1))
        return f'__PH_{len(tokens) - 1}__'

    return PLACEHOLDER_RE.sub(repl, text), tokens


def restore_placeholders(text: str, tokens: list[str]) -> str:
    for i, token in enumerate(tokens):
        text = text.replace(f'__PH_{i}__', token)
        text = text.replace(f'__PH_ {i} __', token)
        text = text.replace(f'__PH_{i} __', token)
        text = text.replace(f'__PH _{i}__', token)
    return text


def translate_text(text: str, target: str, translator: GoogleTranslator) -> str:
    if not text.strip():
        return text
    protected, tokens = protect_placeholders(text)
    # Chunk long strings for API limits.
    if len(protected) > 4500:
        protected = protected[:4500]
    for attempt in range(3):
        try:
            translated = translator.translate(protected)
            return restore_placeholders(translated, tokens)
        except Exception:
            time.sleep(1.2 * (attempt + 1))
    return text


def load_keys() -> dict[str, str]:
    en = json.loads((L10N / 'app_en.arb').read_text(encoding='utf-8'))
    calc = [k for k in en if k.startswith('calc') and not k.startswith('@')]
    other = [
        'appTitle',
        'splashSlogan',
        'splashWaqfByLabel',
        'splashWaqfByTitle',
        'loginTitle',
        'loginSubtitle',
        'loginPhoneLabel',
        'loginPasswordLabel',
        'loginButton',
        'loginPhoneRequired',
        'loginPhoneInvalid',
        'loginSecureNote',
        'loginPasswordRequired',
        'donationCurrencySheetTitle',
        'donationCurrencySheetSubtitle',
        'donationLocalPaymentTitle',
        'donationLocalPaymentSubtitle',
        'donationInternationalPaymentTitle',
        'donationInternationalPaymentSubtitle',
        'donationInternationalTitle',
        'donationInternationalSubtitle',
        'donationAmountLabel',
        'donationAmountHint',
        'donationAmountHelper',
        'donationAnonymousLabel',
        'donationAnonymousSubtitle',
        'donationDonorSectionTitle',
        'donationFullNameLabel',
        'donationPhoneLabel',
        'donationEmailLabel',
        'donationBillingSectionTitle',
        'donationAddress1Label',
        'donationAddress2Label',
        'donationCountryLabel',
        'donationCountryOther',
        'donationAdminAreaLabel',
        'donationLocalityLabel',
        'donationPostalCodeLabel',
        'donationContinueToPayment',
        'donationSubmitting',
        'donationSuccess',
        'donationValidationPhone',
        'donationPaymentWebViewTitle',
        'donationSelectCountry',
        'donationSearchCountry',
        'donationSelectState',
        'donationSearchState',
        'donationNoMatchesFound',
    ]
    keys = other + calc
    return {k: en[k] for k in keys if k in en}


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    keys = load_keys()
    (OUT / '_en_keys.json').write_text(
        json.dumps(keys, ensure_ascii=False, indent=2),
        encoding='utf-8',
    )

    for locale, google_code in LOCALES.items():
        print(f'translating {locale}...')
        translator = GoogleTranslator(source='en', target=google_code)
        translated: dict[str, str] = {}
        for i, (key, value) in enumerate(keys.items(), start=1):
            if key in KEEP_LITERAL:
                translated[key] = value
            else:
                translated[key] = translate_text(value, google_code, translator)
            if i % 20 == 0:
                print(f'  {locale}: {i}/{len(keys)}')
                time.sleep(0.4)

        out_path = OUT / f'{locale}.json'
        out_path.write_text(json.dumps(translated, ensure_ascii=False, indent=2), encoding='utf-8')
        print(f'wrote {out_path}')


if __name__ == '__main__':
    main()
