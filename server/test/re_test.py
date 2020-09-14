from re import match

print(match(r'(\d+)', '5                                               ').group(1))