import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Fix withOpacity deprecation
    new_content = re.sub(r'\.withOpacity\((.*?)\)', r'.withValues(alpha: \1)', content)

    # 2. Fix empty onPressed
    new_content = re.sub(r'onPressed:\s*\(\)\s*\{\},?', r"onPressed: () { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feature coming soon...'))); },", new_content)

    # 3. Fix empty onTap
    new_content = re.sub(r'onTap:\s*\(\)\s*\{\},?', r"onTap: () { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feature coming soon...'))); },", new_content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f'Updated {filepath}')

def main():
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                process_file(os.path.join(root, file))

if __name__ == '__main__':
    main()
