#!/bin/sh

# PFX to PEM/KEY Extractor - OpenSSL wrapper
# Extracts certificate (.pem) and private key (.pem) from PFX file
# POSIX-compliant shell script

set -e

# Usage check
if [ $# -ne 3 ]; then
    echo "Usage: $0 <pfx_file> <password> <output_base>"
    echo ""
    echo "Example:"
    echo "  $0 /tmp/cert_123456.pfx myPassword /tmp/cert_123456"
    echo ""
    echo "Creates:"
    echo "  /tmp/cert_123456.pem (certificate)"
    echo "  /tmp/key_123456.pem  (private key)"
    echo ""
    echo "For n8n:"
    echo "  $0 /tmp/cert_\$timestamp.pfx '\$password' \$timestamp"
    exit 1
fi

PFX_FILE="$1"
PASSWORD="$2"
OUTPUT_BASE="$3"

CERT_FILE="/tmp/cert_${OUTPUT_BASE}.pem"
KEY_FILE="/tmp/key_${OUTPUT_BASE}.pem"

# Validate PFX file exists
if [ ! -f "$PFX_FILE" ]; then
    echo "Error: PFX file not found: $PFX_FILE"
    exit 1
fi

# Extract certificate (cert.pem)
echo "Extracting certificate..."
if openssl pkcs12 -in "$PFX_FILE" \
    -clcerts -nokeys \
    -out "$CERT_FILE" \
    -password "pass:$PASSWORD" \
    -passin "pass:$PASSWORD" 2>/dev/null; then
    echo "Certificate saved: $CERT_FILE"
else
    echo "Failed to extract certificate"
    exit 1
fi

# Extract private key (key.pem)
echo "Extracting private key..."
if openssl pkcs12 -in "$PFX_FILE" \
    -nocerts -nodes \
    -out "$KEY_FILE" \
    -password "pass:$PASSWORD" \
    -passin "pass:$PASSWORD" 2>/dev/null; then
    echo "Private key saved: $KEY_FILE"
else
    echo "Failed to extract private key"
    rm -f "$CERT_FILE"
    exit 1
fi

echo ""
echo "Success! Files created:"
echo "  Certificate: $CERT_FILE"
echo "  Private Key: $KEY_FILE"
exit 0
