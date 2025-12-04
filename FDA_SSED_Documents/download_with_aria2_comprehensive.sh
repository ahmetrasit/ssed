#!/bin/bash

################################################################################
# FDA SSED Documents - aria2c Comprehensive Downloader
################################################################################
#
# This script downloads ALL 407 SSED URLs from ssed_urls.txt (206 PQP devices)
# Automatically skips 404 errors (many supplements don't have public SSEDs)
#
# Installation:
#   Ubuntu/Debian: sudo apt-get install aria2
#   Mac: brew install aria2
#   Windows: Download from https://aria2.github.io/
#
# Usage:
#   chmod +x download_with_aria2_comprehensive.sh
#   ./download_with_aria2_comprehensive.sh
#
# Expected: ~50-100 successful downloads out of 407 URLs
#
################################################################################

set +e  # Don't exit on error (expected 404s)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}FDA SSED Comprehensive Downloader (407 URLs)${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""

# Check if aria2c is installed
if ! command -v aria2c &> /dev/null; then
    echo -e "${RED}[ERROR] aria2c is not installed${NC}"
    echo ""
    echo "Install aria2c:"
    echo "  Ubuntu/Debian: sudo apt-get install aria2"
    echo "  Mac: brew install aria2"
    echo "  Windows: Download from https://aria2.github.io/"
    echo ""
    exit 1
fi

echo -e "${BLUE}[INFO] Using aria2c version:${NC}"
aria2c --version | head -1
echo ""

# Check if ssed_urls.txt exists
if [ ! -f "ssed_urls.txt" ]; then
    echo -e "${RED}[ERROR] ssed_urls.txt not found${NC}"
    echo "Please run this script from the FDA_SSED_Documents directory"
    exit 1
fi

# Generate aria2 input file from ssed_urls.txt
echo -e "${BLUE}[INFO] Generating aria2 input file from ssed_urls.txt...${NC}"

# Parse ssed_urls.txt and create aria2 input format
{
    echo "# Auto-generated aria2 input file from ssed_urls.txt"
    echo "# Total URLs: 407 (many will 404 - expected)"
    echo ""

    while IFS='|' read -r url filename category; do
        # Skip comments and empty lines
        [[ "$url" =~ ^#.*$ ]] && continue
        [[ -z "$url" ]] && continue

        # Output aria2 format: URL then dir/out on next lines
        echo "$url"
        echo "  dir=$category"
        echo "  out=$filename"
        echo ""
    done < ssed_urls.txt
} > aria2_input.txt

# Count URLs
url_count=$(grep -c '^https://' aria2_input.txt)
echo -e "${GREEN}✓ Generated aria2 input with ${url_count} URLs${NC}"
echo ""

# Create directories
echo -e "${BLUE}[INFO] Creating directory structure...${NC}"
mkdir -p NGS_Panels
mkdir -p PCR_Companion_Diagnostics
mkdir -p IHC_Companion_Diagnostics
mkdir -p FISH_Companion_Diagnostics
mkdir -p Liquid_Biopsy
mkdir -p Colorectal_Screening
mkdir -p Digital_Pathology_Systems
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

# aria2c configuration with 404 handling
echo -e "${BLUE}[INFO] Starting comprehensive download...${NC}"
echo ""
echo "Configuration:"
echo "  • 16 connections per file (maximum speed)"
echo "  • 8 concurrent downloads (faster for many files)"
echo "  • Auto-skip 404 errors (expected)"
echo "  • Auto-retry on network failure"
echo "  • Resume support"
echo ""
echo -e "${YELLOW}NOTE: Many 404 errors are expected - supplements don't all have public SSEDs${NC}"
echo -e "${YELLOW}Expected successful downloads: ~50-100 out of ${url_count} URLs${NC}"
echo ""

# Download with aria2c - optimized for many URLs with expected failures
aria2c \
    --input-file=aria2_input.txt \
    --max-connection-per-server=16 \
    --split=16 \
    --max-concurrent-downloads=8 \
    --min-split-size=1M \
    --continue=true \
    --max-tries=3 \
    --retry-wait=2 \
    --timeout=30 \
    --connect-timeout=15 \
    --max-file-not-found=999 \
    --allow-overwrite=false \
    --auto-file-renaming=false \
    --summary-interval=10 \
    --console-log-level=notice \
    --download-result=full \
    2>&1 | tee aria2_download.log

echo ""
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}Download Complete!${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""

# Count successfully downloaded files
total_files=$(find . -name "*.pdf" -type f | wc -l)
echo -e "${BLUE}[INFO] Total PDF files downloaded: ${total_files}${NC}"
echo -e "${BLUE}[INFO] Attempted URLs: ${url_count}${NC}"
echo -e "${BLUE}[INFO] Success rate: $(echo "scale=1; $total_files * 100 / $url_count" | bc)%${NC}"

# Calculate total size
total_size=$(du -sh . 2>/dev/null | cut -f1)
echo -e "${BLUE}[INFO] Total size: ${total_size}${NC}"
echo ""

# Show breakdown by category
echo "Files by category:"
for dir in NGS_Panels PCR_Companion_Diagnostics IHC_Companion_Diagnostics FISH_Companion_Diagnostics Liquid_Biopsy Colorectal_Screening Digital_Pathology_Systems; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "*.pdf" -type f 2>/dev/null | wc -l)
        if [ $count -gt 0 ]; then
            size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            echo "  • $dir: $count files ($size)"
        fi
    fi
done

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo "Download log saved to: aria2_download.log"
echo ""
echo "Next steps:"
echo "  1. Review log: less aria2_download.log"
echo "  2. Verify downloads: find . -name '*.pdf' -exec ls -lh {} \\;"
echo "  3. Commit successful downloads to git"
echo ""
