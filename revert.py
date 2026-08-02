import os, re

files = [
    r'c:\Projects\digikhata_clone\lib\features\stock\presentation\screens\stock_book_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\staff\presentation\screens\staff_book_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\expense\presentation\screens\expense_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\cashbook\presentation\screens\cashbook_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\billing\presentation\screens\bill_book_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\customers\presentation\screens\customer_list_screen.dart'
]

bg_pattern = re.compile(r'(backgroundColor|color):\s*const Color\(0xFF1[258A]1[258A]1[258A]\)')
box_pattern = re.compile(r'color:\s*const Color\(0xFF252525\)')
box_pattern_2 = re.compile(r'color:\s*const Color\(0xFF1E1E1E\)')
text_white_pattern = re.compile(r'color:\s*Colors\.white70')
text_white_2 = re.compile(r'color:\s*Colors\.white54')

for fpath in files:
    if os.path.exists(fpath):
        with open(fpath, 'r', encoding='utf-8') as f:
            content = f.read()
            
        content = bg_pattern.sub(r'\1: Colors.grey.shade50', content)
        content = box_pattern.sub('color: Colors.white', content)
        content = box_pattern_2.sub('color: Colors.white', content)
        content = text_white_pattern.sub('color: Colors.black87', content)
        content = text_white_2.sub('color: Colors.black54', content)
        
        with open(fpath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Processed {os.path.basename(fpath)}')
