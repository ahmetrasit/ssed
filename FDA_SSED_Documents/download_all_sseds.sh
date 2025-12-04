#!/bin/bash

################################################################################
# FDA SSED Documents - Automatic Download Script
################################################################################
#
# This script downloads all SSED (Summary of Safety and Effectiveness Data)
# and regulatory summary documents for FDA-authorized oncology molecular
# diagnostics and digital pathology devices.
#
# Usage:
#   chmod +x download_all_sseds.sh
#   ./download_all_sseds.sh
#
# Note: This script requires internet access to FDA servers
# (www.accessdata.fda.gov)
#
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to download with retry
download_with_retry() {
    local url="$1"
    local output="$2"
    local max_attempts=3
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        print_status "Downloading $output (attempt $attempt/$max_attempts)..."

        if wget --timeout=120 --tries=2 -O "$output" "$url" 2>&1 | grep -q "saved"; then
            print_status "✓ Successfully downloaded $output"
            return 0
        else
            print_warning "Download failed for $output (attempt $attempt)"
            attempt=$((attempt + 1))
            sleep 2
        fi
    done

    print_error "✗ Failed to download $output after $max_attempts attempts"
    return 1
}

print_status "============================================"
print_status "FDA SSED Documents Download Script"
print_status "Starting download process..."
print_status "============================================"

################################################################################
# SECTION 1: NGS PANELS
################################################################################

print_status "\n=== Downloading NGS Panel SSEDs ==="
cd NGS_Panels/

# FoundationOne CDx
print_status "FoundationOne CDx documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf" \
    "FoundationOne_CDx_P170019_Original_SSED.pdf"

download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S029B.pdf" \
    "FoundationOne_CDx_P170019_S029_SSED.pdf"

download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S048B.pdf" \
    "FoundationOne_CDx_P170019_S048_SSED.pdf"

# Oncomine Dx Target Test
print_status "Oncomine Dx Target Test documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf16/p160045b.pdf" \
    "Oncomine_Dx_Target_P160045_Original_SSED.pdf"

# TruSight Oncology Comprehensive
print_status "TruSight Oncology Comprehensive documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230011C.pdf" \
    "TruSight_Oncology_Comprehensive_P230011_Technical_Info.pdf"

cd ..

################################################################################
# SECTION 2: PCR COMPANION DIAGNOSTICS
################################################################################

print_status "\n=== Downloading PCR Companion Diagnostic SSEDs ==="
cd PCR_Companion_Diagnostics/

# cobas BRAF V600
print_status "cobas BRAF V600 documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020b.pdf" \
    "cobas_4800_BRAF_V600_P110020_SSED.pdf"

download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020c.pdf" \
    "cobas_4800_BRAF_V600_P110020_Technical_Info.pdf"

cd ..

################################################################################
# SECTION 3: IHC COMPANION DIAGNOSTICS
################################################################################

print_status "\n=== Downloading IHC Companion Diagnostic SSEDs ==="
cd IHC_Companion_Diagnostics/

# HercepTest
print_status "HercepTest documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf/P980018S010b.pdf" \
    "HercepTest_P980018_S010_SSED.pdf"

cd ..

################################################################################
# SECTION 4: FISH COMPANION DIAGNOSTICS
################################################################################

print_status "\n=== Downloading FISH Companion Diagnostic SSEDs ==="
cd FISH_Companion_Diagnostics/

# PathVysion HER-2
print_status "PathVysion HER-2 documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf/P980024S001c.pdf" \
    "PathVysion_HER2_P980024_S001_Technical_Info.pdf"

cd ..

################################################################################
# SECTION 5: LIQUID BIOPSY TESTS
################################################################################

print_status "\n=== Downloading Liquid Biopsy Test SSEDs ==="
cd Liquid_Biopsy/

# Guardant360 CDx
print_status "Guardant360 CDx documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010B.pdf" \
    "Guardant360_CDx_P200010_Original_SSED.pdf"

download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S008C.pdf" \
    "Guardant360_CDx_P200010_S008_Technical_Info.pdf"

download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S010B.pdf" \
    "Guardant360_CDx_P200010_S010_SSED.pdf"

# FoundationOne Liquid CDx
print_status "FoundationOne Liquid CDx documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf19/P190032C.pdf" \
    "FoundationOne_Liquid_CDx_P190032_Technical_Info.pdf"

cd ..

################################################################################
# SECTION 6: COLORECTAL CANCER SCREENING
################################################################################

print_status "\n=== Downloading Colorectal Screening Test SSEDs ==="
cd Colorectal_Screening/

# Cologuard Plus
print_status "Cologuard Plus documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230043B.pdf" \
    "Cologuard_Plus_P230043_SSED.pdf"

cd ..

################################################################################
# SECTION 7: DIGITAL PATHOLOGY SYSTEMS
################################################################################

print_status "\n=== Downloading Digital Pathology System Summaries ==="
cd Digital_Pathology_Systems/

# Philips IntelliSite (De Novo)
print_status "Philips IntelliSite documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN160056.pdf" \
    "Philips_IntelliSite_DEN160056_De_Novo_Summary.pdf"

download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf16/DEN160056.pdf" \
    "Philips_IntelliSite_DEN160056_Decision_Summary.pdf"

# Hamamatsu NanoZoomer S360MD
print_status "Hamamatsu NanoZoomer documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/reviews/K213883.pdf" \
    "Hamamatsu_NanoZoomer_S360MD_K213883_510k_Summary.pdf"

# Roche VENTANA DP 200
print_status "Roche VENTANA DP 200 documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/reviews/K232879.pdf" \
    "Roche_VENTANA_DP200_K232879_510k_Summary.pdf"

# Paige Prostate (De Novo)
print_status "Paige Prostate AI documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN200080.pdf" \
    "Paige_Prostate_DEN200080_De_Novo_Summary.pdf"

# Prosigna (510k)
print_status "Prosigna PAM50 documents..."
download_with_retry \
    "https://www.accessdata.fda.gov/cdrh_docs/reviews/k130010.pdf" \
    "Prosigna_PAM50_K130010_510k_Summary.pdf"

cd ..

################################################################################
# SUMMARY
################################################################################

print_status "\n============================================"
print_status "Download process completed!"
print_status "============================================"

# Count downloaded files
total_files=$(find . -name "*.pdf" -type f | wc -l)
print_status "Total PDF files downloaded: $total_files"

# Calculate total size
total_size=$(du -sh . | cut -f1)
print_status "Total size: $total_size"

print_status "\nDocuments are organized in the following folders:"
print_status "  - NGS_Panels/"
print_status "  - PCR_Companion_Diagnostics/"
print_status "  - IHC_Companion_Diagnostics/"
print_status "  - FISH_Companion_Diagnostics/"
print_status "  - Liquid_Biopsy/"
print_status "  - Colorectal_Screening/"
print_status "  - Digital_Pathology_Systems/"

print_warning "\nNote: Some documents may not be available publicly or may require"
print_warning "additional steps to access. Check the README.md files in each folder"
print_warning "for alternative download methods and FDA database search instructions."

print_status "\nDone!"
