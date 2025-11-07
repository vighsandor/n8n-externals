#!/bin/sh
TIMESTAMP=$1
rm -f /tmp/cert_${TIMESTAMP}.pfx
rm -f /tmp/cert_${TIMESTAMP}.pem
rm -f /tmp/key_${TIMESTAMP}.pem
rm -f /tmp/input_${TIMESTAMP}.pdf
rm -f /tmp/output_${TIMESTAMP}.pdf
rm -f /tmp/test*
rm -f /tmp/*.sh
