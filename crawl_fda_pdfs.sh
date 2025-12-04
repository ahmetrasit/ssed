#!/bin/bash

################################################################################
# FDA PMA PDF Crawler - Example Usage Script
################################################################################
#
# This script demonstrates how to use pdf_crawler.py to extract all PDF links
# from FDA PMA database pages.
#
# Usage:
#   chmod +x crawl_fda_pdfs.sh
#   ./crawl_fda_pdfs.sh <PMA_NUMBER>
#
# Example:
#   ./crawl_fda_pdfs.sh P170019  # FoundationOne CDx
#   ./crawl_fda_pdfs.sh P200010  # Guardant360 CDx
#
################################################################################

set -e

# Check if PMA number provided
if [ -z "$1" ]; then
    echo "Usage: $0 <PMA_NUMBER>"
    echo ""
    echo "Examples:"
    echo "  $0 P170019  # FoundationOne CDx"
    echo "  $0 P200010  # Guardant360 CDx"
    echo "  $0 P160045  # Oncomine Dx Target"
    exit 1
fi

PMA=$1
OUTPUT_FILE="fda_pdfs_${PMA}.txt"
STATE_FILE="crawler_state_${PMA}.json"

# FDA PMA page URL
START_URL="https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=${PMA}"

echo "=========================================="
echo "FDA PMA PDF Crawler"
echo "=========================================="
echo "PMA Number: $PMA"
echo "Starting URL: $START_URL"
echo "Output: $OUTPUT_FILE"
echo "=========================================="
echo ""

# Install dependencies if needed
if ! python3 -c "import requests, bs4" 2>/dev/null; then
    echo "Installing required Python packages..."
    pip3 install requests beautifulsoup4
    echo ""
fi

# Run crawler
python3 pdf_crawler.py "$START_URL" \
    --max-pages 100 \
    --delay 1.0 \
    --output "$OUTPUT_FILE" \
    --resume-file "$STATE_FILE"

echo ""
echo "Done! PDF links saved to: $OUTPUT_FILE"
echo ""
echo "To resume this crawl later, run:"
echo "  python3 pdf_crawler.py \"$START_URL\" --resume --resume-file \"$STATE_FILE\" --output \"$OUTPUT_FILE\""
