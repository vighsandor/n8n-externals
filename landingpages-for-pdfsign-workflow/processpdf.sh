#!/bin/bash

# PDF Signing Script - Unified wrapper for open-pdf-sign.jar
# Supports multiple signing modes: basic, timestamp, baseline-lt, baseline-lta

set -e

# Default values
JAR_PATH="/tmp/open-pdf-sign.jar"
INPUT_FILE=""
OUTPUT_FILE=""
CERT_FILE=""
KEY_FILE=""
PAGE="1"
IMAGE_FILE="/tmp/logo.png"
TSA_URL="http://timestamp.digicert.com"
MODE="basic"

# Usage function
usage() {
    cat << EOF
Usage: $0 -i INPUT -o OUTPUT -c CERT -k KEY [OPTIONS]

Required arguments:
  -i INPUT        Input PDF file path
  -o OUTPUT       Output PDF file path
  -c CERT         Certificate PEM file path
  -k KEY          Private key PEM file path

Optional arguments:
  -m MODE         Signing mode: basic|timestamp|baseline-lt|baseline-lta (default: basic)
  -p PAGE         Page number for signature (default: 1)
  -g IMAGE        Signature image file path (default: /tmp/logo.png)
  -t TSA_URL      Timestamp authority URL (default: http://timestamp.digicert.com)
  -j JAR_PATH     Path to open-pdf-sign.jar (default: /tmp/open-pdf-sign.jar)
  -h              Show this help message

Signing modes:
  basic           Simple signature without timestamp
  timestamp       Signature with timestamp
  baseline-lt     Signature with timestamp and baseline-lt profile
  baseline-lta    Signature with timestamp and baseline-lta profile

Examples:
  # Basic signing
  $0 -i input.pdf -o output.pdf -c cert.pem -k key.pem

  # With timestamp
  $0 -i input.pdf -o output.pdf -c cert.pem -k key.pem -m timestamp

  # With baseline-lt profile
  $0 -i input.pdf -o output.pdf -c cert.pem -k key.pem -m baseline-lt

  # With baseline-lta profile and custom image
  $0 -i input.pdf -o output.pdf -c cert.pem -k key.pem -m baseline-lta -g /path/to/logo.png

EOF
    exit 1
}

# Parse command line arguments
while getopts "i:o:c:k:m:p:g:t:j:h" opt; do
    case $opt in
        i) INPUT_FILE="$OPTARG" ;;
        o) OUTPUT_FILE="$OPTARG" ;;
        c) CERT_FILE="$OPTARG" ;;
        k) KEY_FILE="$OPTARG" ;;
        m) MODE="$OPTARG" ;;
        p) PAGE="$OPTARG" ;;
        g) IMAGE_FILE="$OPTARG" ;;
        t) TSA_URL="$OPTARG" ;;
        j) JAR_PATH="$OPTARG" ;;
        h) usage ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
    esac
done

# Validate required arguments
if [[ -z "$INPUT_FILE" ]] || [[ -z "$OUTPUT_FILE" ]] || [[ -z "$CERT_FILE" ]] || [[ -z "$KEY_FILE" ]]; then
    echo "Error: Missing required arguments"
    echo ""
    usage
fi

# Validate files exist
if [[ ! -f "$JAR_PATH" ]]; then
    echo "Error: JAR file not found: $JAR_PATH"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file not found: $INPUT_FILE"
    exit 1
fi

if [[ ! -f "$CERT_FILE" ]]; then
    echo "Error: Certificate file not found: $CERT_FILE"
    exit 1
fi

if [[ ! -f "$KEY_FILE" ]]; then
    echo "Error: Key file not found: $KEY_FILE"
    exit 1
fi

if [[ ! -f "$IMAGE_FILE" ]]; then
    echo "Error: Image file not found: $IMAGE_FILE"
    exit 1
fi

# Validate mode
if [[ ! "$MODE" =~ ^(basic|timestamp|baseline-lt|baseline-lta)$ ]]; then
    echo "Error: Invalid mode: $MODE"
    echo "Valid modes: basic, timestamp, baseline-lt, baseline-lta"
    exit 1
fi

# Build the command based on mode
BASE_CMD="java -jar $JAR_PATH -i $INPUT_FILE -o $OUTPUT_FILE -c $CERT_FILE -k $KEY_FILE"

case $MODE in
    basic)
        CMD="$BASE_CMD --page $PAGE --image $IMAGE_FILE"
        ;;
    timestamp)
        CMD="$BASE_CMD --timestamp --tsa $TSA_URL --page $PAGE --image $IMAGE_FILE"
        ;;
    baseline-lt)
        CMD="$BASE_CMD --timestamp --tsa $TSA_URL --baseline-lt --page $PAGE --image $IMAGE_FILE"
        ;;
    baseline-lta)
        CMD="$BASE_CMD --timestamp --tsa $TSA_URL --baseline-lta --page $PAGE --image $IMAGE_FILE"
        ;;
esac

# Execute the command
echo "Executing: $CMD"
echo ""
eval $CMD

# Check result
if [[ $? -eq 0 ]]; then
    echo ""
    echo "Success! PDF signed and saved to: $OUTPUT_FILE"
    exit 0
else
    echo ""
    echo "Error: PDF signing failed"
    exit 1
fi
