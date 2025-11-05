#!/bin/sh

# PDF Signing Script - Unified wrapper for open-pdf-sign.jar
# POSIX-compliant version for sh shell
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
VISIBLE_SIGNATURE="no"

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
  -v              Enable visible signature (use --page and --image parameters)
  -p PAGE         Page number for signature (default: 1, only used with -v)
  -g IMAGE        Signature image file path (default: /tmp/logo.png, only used with -v)
  -t TSA_URL      Timestamp authority URL (default: http://timestamp.digicert.com)
  -j JAR_PATH     Path to open-pdf-sign.jar (default: /tmp/open-pdf-sign.jar)
  -h              Show this help message

Signing modes:
  basic           Simple signature without timestamp
  timestamp       Signature with timestamp
  baseline-lt     Signature with timestamp and baseline-lt profile
  baseline-lta    Signature with timestamp and baseline-lta profile

Examples:
  # Basic signing without visible signature
  $0 -i input.pdf -o output.pdf -c cert.pem -k key.pem

  # With timestamp and visible signature
  $0 -i input.pdf -o output.pdf -c cert.pem -k key.pem -m timestamp -v

  # With baseline-lt profile and visible signature on page 2
  $0 -i input.pdf -o output.pdf -c cert.pem -k key.pem -m baseline-lt -v -p 2

  # With baseline-lta profile, visible signature and custom image
  $0 -i input.pdf -o output.pdf -c cert.pem -k key.pem -m baseline-lta -v -g /path/to/logo.png

EOF
    exit 1
}

# Parse command line arguments
while getopts "i:o:c:k:m:p:g:t:j:vh" opt; do
    case $opt in
        i) INPUT_FILE="$OPTARG" ;;
        o) OUTPUT_FILE="$OPTARG" ;;
        c) CERT_FILE="$OPTARG" ;;
        k) KEY_FILE="$OPTARG" ;;
        m) MODE="$OPTARG" ;;
        v) VISIBLE_SIGNATURE="yes" ;;
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
if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_FILE" ] || [ -z "$CERT_FILE" ] || [ -z "$KEY_FILE" ]; then
    echo "Error: Missing required arguments"
    echo ""
    usage
fi

# Validate files exist
if [ ! -f "$JAR_PATH" ]; then
    echo "Error: JAR file not found: $JAR_PATH"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found: $INPUT_FILE"
    exit 1
fi

if [ ! -f "$CERT_FILE" ]; then
    echo "Error: Certificate file not found: $CERT_FILE"
    exit 1
fi

if [ ! -f "$KEY_FILE" ]; then
    echo "Error: Key file not found: $KEY_FILE"
    exit 1
fi

# Validate image file only if visible signature is enabled
if [ "$VISIBLE_SIGNATURE" = "yes" ]; then
    if [ ! -f "$IMAGE_FILE" ]; then
        echo "Error: Image file not found: $IMAGE_FILE"
        exit 1
    fi
fi

# Validate mode (POSIX-compliant way)
case "$MODE" in
    basic|timestamp|baseline-lt|baseline-lta)
        # Valid mode
        ;;
    *)
        echo "Error: Invalid mode: $MODE"
        echo "Valid modes: basic, timestamp, baseline-lt, baseline-lta"
        exit 1
        ;;
esac

# Build the command based on mode
BASE_CMD="java -jar $JAR_PATH -i $INPUT_FILE -o $OUTPUT_FILE -c $CERT_FILE -k $KEY_FILE"

# Add visible signature parameters if enabled
if [ "$VISIBLE_SIGNATURE" = "yes" ]; then
    SIGNATURE_PARAMS="--page $PAGE --image $IMAGE_FILE"
else
    SIGNATURE_PARAMS=""
fi

case $MODE in
    basic)
        CMD="$BASE_CMD $SIGNATURE_PARAMS"
        ;;
    timestamp)
        CMD="$BASE_CMD --timestamp --tsa $TSA_URL $SIGNATURE_PARAMS"
        ;;
    baseline-lt)
        CMD="$BASE_CMD --timestamp --tsa $TSA_URL --baseline-lt $SIGNATURE_PARAMS"
        ;;
    baseline-lta)
        CMD="$BASE_CMD --timestamp --tsa $TSA_URL --baseline-lta $SIGNATURE_PARAMS"
        ;;
esac

# Execute the command
echo "Executing: $CMD"
echo ""
eval $CMD

# Check result
if [ $? -eq 0 ]; then
    echo ""
    echo "Success! PDF signed and saved to: $OUTPUT_FILE"
    exit 0
else
    echo ""
    echo "Error: PDF signing failed"
    exit 1
fi
