#!/usr/bin/env python3
"""
FDA SSED Documents - Python Downloader
Uses Python requests library which may handle proxies differently than wget/curl
"""

import os
import sys
import time
import requests
from pathlib import Path

# Color codes for terminal output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
NC = '\033[0m'  # No Color

def print_status(message):
    print(f"{GREEN}[INFO]{NC} {message}")

def print_error(message):
    print(f"{RED}[ERROR]{NC} {message}")

def print_warning(message):
    print(f"{YELLOW}[WARNING]{NC} {message}")

# List of files to download: (URL, output_path, description)
DOWNLOADS = [
    # NGS Panels
    ("https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf",
     "NGS_Panels/FoundationOne_CDx_P170019_Original_SSED.pdf",
     "FoundationOne CDx Original SSED"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S029B.pdf",
     "NGS_Panels/FoundationOne_CDx_P170019_S029_SSED.pdf",
     "FoundationOne CDx S029 SSED"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S048B.pdf",
     "NGS_Panels/FoundationOne_CDx_P170019_S048_SSED.pdf",
     "FoundationOne CDx S048 SSED"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf16/p160045b.pdf",
     "NGS_Panels/Oncomine_Dx_Target_P160045_Original_SSED.pdf",
     "Oncomine Dx Target Test SSED"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230011C.pdf",
     "NGS_Panels/TruSight_Oncology_Comprehensive_P230011_Technical_Info.pdf",
     "TruSight Oncology Comprehensive"),

    # PCR Companion Diagnostics
    ("https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020b.pdf",
     "PCR_Companion_Diagnostics/cobas_4800_BRAF_V600_P110020_SSED.pdf",
     "cobas BRAF V600 SSED"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020c.pdf",
     "PCR_Companion_Diagnostics/cobas_4800_BRAF_V600_P110020_Technical_Info.pdf",
     "cobas BRAF V600 Technical Info"),

    # IHC Companion Diagnostics
    ("https://www.accessdata.fda.gov/cdrh_docs/pdf/P980018S010b.pdf",
     "IHC_Companion_Diagnostics/HercepTest_P980018_S010_SSED.pdf",
     "HercepTest SSED"),

    # FISH Companion Diagnostics
    ("https://www.accessdata.fda.gov/cdrh_docs/pdf/P980024S001c.pdf",
     "FISH_Companion_Diagnostics/PathVysion_HER2_P980024_S001_Technical_Info.pdf",
     "PathVysion HER2 Technical Info"),

    # Liquid Biopsy
    ("https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010B.pdf",
     "Liquid_Biopsy/Guardant360_CDx_P200010_Original_SSED.pdf",
     "Guardant360 CDx Original SSED"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S008C.pdf",
     "Liquid_Biopsy/Guardant360_CDx_P200010_S008_Technical_Info.pdf",
     "Guardant360 CDx S008 Technical Info"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S010B.pdf",
     "Liquid_Biopsy/Guardant360_CDx_P200010_S010_SSED.pdf",
     "Guardant360 CDx S010 SSED"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf19/P190032C.pdf",
     "Liquid_Biopsy/FoundationOne_Liquid_CDx_P190032_Technical_Info.pdf",
     "FoundationOne Liquid CDx Technical Info"),

    # Colorectal Screening
    ("https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230043B.pdf",
     "Colorectal_Screening/Cologuard_Plus_P230043_SSED.pdf",
     "Cologuard Plus SSED"),

    # Digital Pathology Systems
    ("https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN160056.pdf",
     "Digital_Pathology_Systems/Philips_IntelliSite_DEN160056_De_Novo_Summary.pdf",
     "Philips IntelliSite De Novo Summary"),

    ("https://www.accessdata.fda.gov/cdrh_docs/pdf16/DEN160056.pdf",
     "Digital_Pathology_Systems/Philips_IntelliSite_DEN160056_Decision_Summary.pdf",
     "Philips IntelliSite Decision Summary"),

    ("https://www.accessdata.fda.gov/cdrh_docs/reviews/K213883.pdf",
     "Digital_Pathology_Systems/Hamamatsu_NanoZoomer_S360MD_K213883_510k_Summary.pdf",
     "Hamamatsu NanoZoomer 510k Summary"),

    ("https://www.accessdata.fda.gov/cdrh_docs/reviews/K232879.pdf",
     "Digital_Pathology_Systems/Roche_VENTANA_DP200_K232879_510k_Summary.pdf",
     "Roche VENTANA DP 200 510k Summary"),

    ("https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN200080.pdf",
     "Digital_Pathology_Systems/Paige_Prostate_DEN200080_De_Novo_Summary.pdf",
     "Paige Prostate De Novo Summary"),

    ("https://www.accessdata.fda.gov/cdrh_docs/reviews/k130010.pdf",
     "Digital_Pathology_Systems/Prosigna_PAM50_K130010_510k_Summary.pdf",
     "Prosigna PAM50 510k Summary"),
]

def download_file(url, output_path, description, max_retries=3):
    """Download a single file with retry logic"""

    # Create directory if it doesn't exist
    Path(output_path).parent.mkdir(parents=True, exist_ok=True)

    # Check if file already exists
    if os.path.exists(output_path):
        file_size = os.path.getsize(output_path)
        if file_size > 1000:  # More than 1KB
            print_warning(f"File already exists ({file_size:,} bytes): {output_path}")
            return True

    for attempt in range(1, max_retries + 1):
        try:
            print_status(f"Downloading {description} (attempt {attempt}/{max_retries})...")
            print_status(f"  URL: {url}")
            print_status(f"  Output: {output_path}")

            # Make request with timeout
            response = requests.get(url, timeout=120, stream=True)
            response.raise_for_status()

            # Get file size
            total_size = int(response.headers.get('content-length', 0))

            # Download with progress
            downloaded = 0
            with open(output_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
                        downloaded += len(chunk)
                        if total_size > 0:
                            percent = (downloaded / total_size) * 100
                            print(f"\r  Progress: {percent:.1f}% ({downloaded:,} / {total_size:,} bytes)", end='')

            print()  # New line after progress
            file_size = os.path.getsize(output_path)
            print_status(f"✓ Successfully downloaded {description} ({file_size:,} bytes)")
            return True

        except requests.exceptions.ProxyError as e:
            print_error(f"Proxy error: {e}")
            if attempt == max_retries:
                print_error(f"✗ Failed to download {description} - Proxy blocking access")
                return False
            time.sleep(2 ** attempt)  # Exponential backoff

        except requests.exceptions.RequestException as e:
            print_error(f"Download error: {e}")
            if attempt == max_retries:
                print_error(f"✗ Failed to download {description} after {max_retries} attempts")
                return False
            time.sleep(2 ** attempt)  # Exponential backoff

        except Exception as e:
            print_error(f"Unexpected error: {e}")
            if attempt == max_retries:
                print_error(f"✗ Failed to download {description}")
                return False
            time.sleep(2 ** attempt)

    return False

def main():
    print_status("=" * 60)
    print_status("FDA SSED Documents - Python Downloader")
    print_status("=" * 60)
    print()

    successful = 0
    failed = 0
    skipped = 0

    total = len(DOWNLOADS)

    for i, (url, output_path, description) in enumerate(DOWNLOADS, 1):
        print_status(f"\n[{i}/{total}] Processing: {description}")

        if download_file(url, output_path, description):
            if os.path.exists(output_path) and os.path.getsize(output_path) > 1000:
                successful += 1
            else:
                skipped += 1
        else:
            failed += 1

    print()
    print_status("=" * 60)
    print_status("Download Summary")
    print_status("=" * 60)
    print_status(f"Total files: {total}")
    print_status(f"✓ Successful: {successful}")
    print_warning(f"⊘ Skipped (already exist): {skipped}")
    print_error(f"✗ Failed: {failed}")

    if failed > 0:
        print()
        print_warning("Some downloads failed. This may be due to:")
        print_warning("  1. Proxy blocking FDA domains")
        print_warning("  2. Network connectivity issues")
        print_warning("  3. FDA server unavailable")
        print()
        print_warning("Solution: Run this script on your local machine where browser access works")
        print_warning("See BROWSER_DOWNLOAD_GUIDE.md for alternative download methods")

    return 0 if failed == 0 else 1

if __name__ == "__main__":
    sys.exit(main())
