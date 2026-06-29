"""Restore ICU placeholders broken by machine translation in override JSON files."""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / 'lib' / 'l10n'
OVERRIDES = Path(__file__).resolve().parent / 'l10n_overrides'

PH_TOKEN = re.compile(r'__PH_(\d+)__')
BROKEN_PH = re.compile(r'_PH_\s*(\d+)\s*_')
EN_PLACEHOLDER = re.compile(r'\{[^{}]+\}')


def placeholders(text: str) -> list[str]:
    return EN_PLACEHOLDER.findall(text)


def fix_value(en_value: str, translated: str) -> str:
    tokens = placeholders(en_value)
    if not tokens:
        return translated

    result = translated
    for match in PH_TOKEN.finditer(en_value):
        idx = int(match.group(1))
        if idx < len(tokens):
            result = result.replace(match.group(0), tokens[idx], 1)

    for match in BROKEN_PH.finditer(result):
        idx = int(match.group(1))
        if idx < len(tokens):
            result = result.replace(match.group(0), tokens[idx], 1)

    return result


def main() -> None:
    en = json.loads((L10N / 'app_en.arb').read_text(encoding='utf-8'))
    fixed = 0
    for path in sorted(OVERRIDES.glob('*.json')):
        if path.name == '_en_keys.json':
            continue
        data = json.loads(path.read_text(encoding='utf-8'))
        locale_fixed = 0
        for key, value in data.items():
            if key not in en or not isinstance(value, str):
                continue
            repaired = fix_value(en[key], value)
            if repaired != value:
                data[key] = repaired
                locale_fixed += 1
        if locale_fixed:
            path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            print(f'{path.name}: fixed {locale_fixed} placeholders')
            fixed += locale_fixed
    print(f'done — {fixed} values repaired')


if __name__ == '__main__':
    main()
