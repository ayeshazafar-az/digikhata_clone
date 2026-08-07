
with open('lib/features/customers/presentation/screens/customer_list_screen.dart', 'r', encoding='utf-8', errors='ignore') as f:
    for i, line in enumerate(f.read().splitlines()):
        print(f'{i+1}: {line}')

