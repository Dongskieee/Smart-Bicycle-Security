import sys
import os
try:
    import qrcode
except ImportError:
    print('qrcode module not found; please install with: pip install qrcode[pil]')
    sys.exit(2)

if len(sys.argv) < 2:
    print('Usage: python generate_qr.py <url> [output_path]')
    sys.exit(1)

url = sys.argv[1]
output = sys.argv[2] if len(sys.argv) >= 3 else 'apk_download_qr.png'

img = qrcode.make(url)
img.save(output)
print(f'QR code generated and saved to: {os.path.abspath(output)}')
