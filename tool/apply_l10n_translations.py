"""Merge locale-specific string overrides into lib/l10n/app_*.arb files."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / 'lib' / 'l10n'
OVERRIDES = Path(__file__).resolve().parent / 'l10n_overrides'


def load_json(path: Path) -> dict:
    with path.open(encoding='utf-8') as f:
        return json.load(f)


def save_arb(path: Path, data: dict) -> None:
    with path.open('w', encoding='utf-8', newline='\n') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')


def merge_locale(locale: str) -> int:
    en = load_json(L10N / 'app_en.arb')
    target_path = L10N / f'app_{locale}.arb'
    target = load_json(target_path)
    overrides_path = OVERRIDES / f'{locale}.json'
    if not overrides_path.exists():
        print(f'skip {locale}: no overrides file')
        return 0

    overrides = load_json(overrides_path)
    updated = 0
    for key, value in overrides.items():
        if key.startswith('@'):
            continue
        target[key] = value
        updated += 1
        meta_key = f'@{key}'
        if meta_key in en:
            target[meta_key] = en[meta_key]

    save_arb(target_path, target)
    print(f'{locale}: updated {updated} keys')
    return updated


def main() -> None:
    total = 0
    for locale in ('am', 'ar', 'om', 'so'):
        total += merge_locale(locale)
    print(f'done — {total} keys updated across locales')


if __name__ == '__main__':
    main()
