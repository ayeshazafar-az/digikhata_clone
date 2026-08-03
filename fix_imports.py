import os

files = [
    r'c:\Projects\digikhata_clone\lib\features\stock\presentation\screens\stock_book_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\staff\presentation\screens\staff_book_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\expense\presentation\screens\expense_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\cashbook\presentation\screens\cashbook_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\billing\presentation\screens\bill_book_screen.dart'
]

import_statement = "import '../../../../app/theme.dart';\n"

for fpath in files:
    if not os.path.exists(fpath): continue
    
    with open(fpath, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'theme.dart' not in content and 'AppTheme' in content:
        # insert right after the first line (which is usually import 'package:flutter/material.dart';)
        lines = content.split('\n')
        lines.insert(1, import_statement)
        with open(fpath, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
        print(f'Import added to {os.path.basename(fpath)}')
