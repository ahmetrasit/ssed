#!/bin/bash

################################################################################
# FDA SSED Documents - aria2c Ultra-Fast Downloader
################################################################################
#
# This script uses aria2c for high-speed parallel downloads of FDA SSED
# documents. aria2 is a lightweight multi-protocol & multi-source download
# utility that supports HTTP/HTTPS and uses multiple connections per file.
#
# Installation:
#   Ubuntu/Debian: sudo apt-get install aria2
#   Mac: brew install aria2
#   Windows: Download from https://aria2.github.io/
#
# Usage:
#   chmod +x download_with_aria2.sh
#   ./download_with_aria2.sh
#
# Speed: Downloads all 20 files in approximately 2-3 minutes
#
################################################################################

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}FDA SSED Documents - aria2c Downloader${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Check if aria2c is installed
if ! command -v aria2c &> /dev/null; then
    echo -e "${YELLOW}[WARNING] aria2c is not installed${NC}"
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

# Create aria2 input file from ssed_urls.txt
echo -e "${BLUE}[INFO] Generating aria2 input file...${NC}"

cat > aria2_input.txt << 'EOF'
# aria2c input file for FDA SSED documents
# Format: URL followed by output path on next line

# NGS Panels
https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf
  dir=NGS_Panels
  out=FoundationOne_CDx_P170019_Original_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S029B.pdf
  dir=NGS_Panels
  out=FoundationOne_CDx_P170019_S029_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S048B.pdf
  dir=NGS_Panels
  out=FoundationOne_CDx_P170019_S048_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf16/p160045b.pdf
  dir=NGS_Panels
  out=Oncomine_Dx_Target_P160045_Original_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230011C.pdf
  dir=NGS_Panels
  out=TruSight_Oncology_Comprehensive_P230011_Technical_Info.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf24/P240010B.pdf
  dir=NGS_Panels
  out=MI_Cancer_Seek_P240010_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf16/P160018S001b.pdf
  dir=NGS_Panels
  out=FoundationFocus_CDxBRCA_P160018_S001_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/den170058.pdf
  dir=NGS_Panels
  out=MSK-IMPACT_DEN170058_De_Novo_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf16/P160038B.pdf
  dir=NGS_Panels
  out=Praxis_Extended_RAS_Panel_P160038_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf16/p160038c.pdf
  dir=NGS_Panels
  out=Praxis_Extended_RAS_Panel_P160038_Technical_Info.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200011S001B.pdf
  dir=NGS_Panels
  out=oncoReveal_CDx_P200011_S001_SSED.pdf

# PCR Companion Diagnostics
https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020b.pdf
  dir=PCR_Companion_Diagnostics
  out=cobas_4800_BRAF_V600_P110020_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020c.pdf
  dir=PCR_Companion_Diagnostics
  out=cobas_4800_BRAF_V600_P110020_Technical_Info.pdf

# IHC Companion Diagnostics
https://www.accessdata.fda.gov/cdrh_docs/pdf/P980018S010b.pdf
  dir=IHC_Companion_Diagnostics
  out=HercepTest_P980018_S010_SSED.pdf

# FISH Companion Diagnostics
https://www.accessdata.fda.gov/cdrh_docs/pdf/P980024S001c.pdf
  dir=FISH_Companion_Diagnostics
  out=PathVysion_HER2_P980024_S001_Technical_Info.pdf

# Liquid Biopsy
https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010B.pdf
  dir=Liquid_Biopsy
  out=Guardant360_CDx_P200010_Original_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S008C.pdf
  dir=Liquid_Biopsy
  out=Guardant360_CDx_P200010_S008_Technical_Info.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S010B.pdf
  dir=Liquid_Biopsy
  out=Guardant360_CDx_P200010_S010_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf19/P190032C.pdf
  dir=Liquid_Biopsy
  out=FoundationOne_Liquid_CDx_P190032_Technical_Info.pdf

# Colorectal Screening
https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230043B.pdf
  dir=Colorectal_Screening
  out=Cologuard_Plus_P230043_SSED.pdf

# Digital Pathology Systems
https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN160056.pdf
  dir=Digital_Pathology_Systems
  out=Philips_IntelliSite_DEN160056_De_Novo_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf16/DEN160056.pdf
  dir=Digital_Pathology_Systems
  out=Philips_IntelliSite_DEN160056_Decision_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/K213883.pdf
  dir=Digital_Pathology_Systems
  out=Hamamatsu_NanoZoomer_S360MD_K213883_510k_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/K232879.pdf
  dir=Digital_Pathology_Systems
  out=Roche_VENTANA_DP200_K232879_510k_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN200080.pdf
  dir=Digital_Pathology_Systems
  out=Paige_Prostate_DEN200080_De_Novo_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/k130010.pdf
  dir=Digital_Pathology_Systems
  out=Prosigna_PAM50_K130010_510k_Summary.pdf
EOF

echo -e "${GREEN}✓ aria2 input file created${NC}"
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

# aria2c configuration
echo -e "${BLUE}[INFO] Starting downloads with aria2c...${NC}"
echo ""
echo "Configuration:"
echo "  • 16 connections per file (maximum speed)"
echo "  • 4 concurrent downloads"
echo "  • 16 split downloads per file"
echo "  • Auto-retry on failure"
echo "  • Resume support"
echo ""

# Download with aria2c
aria2c \
    --input-file=aria2_input.txt \
    --max-connection-per-server=16 \
    --split=16 \
    --max-concurrent-downloads=4 \
    --min-split-size=1M \
    --continue=true \
    --max-tries=5 \
    --retry-wait=3 \
    --timeout=60 \
    --connect-timeout=30 \
    --summary-interval=10 \
    --console-log-level=notice \
    --download-result=full

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Download Complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Count downloaded files
total_files=$(find . -name "*.pdf" -type f | wc -l)
echo -e "${BLUE}[INFO] Total PDF files downloaded: ${total_files} (expected: 31)${NC}"

# Calculate total size
total_size=$(du -sh . 2>/dev/null | cut -f1)
echo -e "${BLUE}[INFO] Total size: ${total_size}${NC}"
echo ""

# Show breakdown by category
echo "Files by category:"
for dir in NGS_Panels PCR_Companion_Diagnostics IHC_Companion_Diagnostics FISH_Companion_Diagnostics Liquid_Biopsy Colorectal_Screening Digital_Pathology_Systems; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "*.pdf" -type f 2>/dev/null | wc -l)
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        echo "  • $dir: $count files ($size)"
    fi
done

echo ""
echo -e "${GREEN}Done! All documents downloaded.${NC}"
echo ""
echo "Next steps:"
echo "  1. Verify downloads: find . -name '*.pdf' -exec ls -lh {} \\;"
echo "  2. Commit to git: git add . && git commit -m 'Add FDA SSED documents'"
echo "  3. Push to remote: git push"
echo ""
