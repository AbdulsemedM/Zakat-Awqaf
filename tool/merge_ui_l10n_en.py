"""Merge EN UI strings into all locale arb files (English fallback for non-en)."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / 'lib' / 'l10n'

# Import from add_ui_l10n to avoid duplication
import importlib.util

spec = importlib.util.spec_from_file_location(
    'add_ui_l10n', Path(__file__).with_name('add_ui_l10n.py')
)
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
EN_STRINGS = mod.EN_STRINGS


def merge(path: Path) -> None:
    data = json.loads(path.read_text(encoding='utf-8'))
    data.update(EN_STRINGS)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def main() -> None:
    for path in sorted(L10N.glob('app_*.arb')):
        merge(path)
        print(f'merged {len(EN_STRINGS)} keys into {path.name}')
    print('done')


if __name__ == '__main__':
    main()
