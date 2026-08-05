import os

for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            if '0xFFF3752A' in content or '0xFFE94326' in content:
                print(f'Updating {path}')
                content = content.replace('Color(0xFFF3752A)', 'Color(0xFF1E3A8A)')
                content = content.replace('Color(0xFFE94326)', 'Color(0xFF60A5FA)')
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
