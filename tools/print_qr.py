import sys
try:
    import qrcode
except Exception:
    print('qrcode not installed')
    sys.exit(2)

if len(sys.argv) < 2:
    print('Usage: print_qr.py <url>')
    sys.exit(1)

url = sys.argv[1]
qr = qrcode.QRCode(border=2)
qr.add_data(url)
qr.make(fit=True)
matrix = qr.get_matrix()

# Print as terminal-friendly ASCII (use two characters per module for square look)
black = "██"
white = "  "
for row in matrix:
    line = ''.join([black if cell else white for cell in row])
    print(line)

print('\nURL:', url)
