import os
import re

files = [
    r'c:\Projects\digikhata_clone\lib\features\stock\presentation\screens\stock_book_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\staff\presentation\screens\staff_book_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\expense\presentation\screens\expense_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\cashbook\presentation\screens\cashbook_screen.dart',
    r'c:\Projects\digikhata_clone\lib\features\billing\presentation\screens\bill_book_screen.dart'
]

# We want to change the AppBar backgroundColor from Colors.grey.shade50 to AppTheme.primaryBlue
for fpath in files:
    if not os.path.exists(fpath): continue
    
    with open(fpath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Step 1: Repair the AppBar background
    appbar_pattern = re.compile(r'(appBar:\s*AppBar\([\s\S]*?backgroundColor:\s*)Colors\.grey\.shade50')
    content = appbar_pattern.sub(r'\1AppTheme.primaryBlue', content)

    # Step 2: Ensure any Colors.white text in the body of the screens are changed to Colors.black87
    # Note: We don't want to change Colors.white inside the AppBar. So let's isolate the body.
    # A simple trick: 
    body_split = content.split('body:')
    if len(body_split) > 1:
        header = body_split[0]
        body = 'body:' + body_split[1]
        
        # Replace Colors.white with Colors.black87 in the body, but leave Colors.white for ElevatedButton text...
        # Let's target specific TextStyles
        body = body.replace('color: Colors.white,', 'color: Colors.black87,')
        body = body.replace('color: Colors.white)', 'color: Colors.black87)')
        
        # Fix ElevatedButtons (if they got changed) by making sure ElevatedButton foreground is white if it was meant to be. 
        # But actually in my older dark mode code, the buttons might have had primaryBlue background, white text.
        # This will change it to black text. Let's fix that.
        body = body.replace('foregroundColor: Colors.black87,', 'foregroundColor: Colors.white,')
        
        content = header + body

    with open(fpath, 'w', encoding='utf-8') as f:
        f.write(content)
        
    print(f'Repaired {os.path.basename(fpath)}')
