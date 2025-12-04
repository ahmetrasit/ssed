# Quick Start Guide - Downloading FDA SSED Documents

This guide provides multiple methods to download all FDA SSED (Summary of Safety and Effectiveness Data) documents for oncology devices.

## Prerequisites

- Internet access to FDA servers (accessdata.fda.gov)
- `wget` or `curl` installed
- Approximately 500 MB free disk space

---

## Method 1: Automated Bash Script (Recommended)

The easiest way to download all documents:

```bash
cd FDA_SSED_Documents/
./download_all_sseds.sh
```

This script:
- Downloads all 20+ SSED documents automatically
- Organizes files into appropriate folders
- Includes retry logic for failed downloads
- Provides progress information

**Estimated time**: 10-15 minutes depending on connection speed

---

## Method 2: Batch Download with URL List

Using the pre-formatted URL list:

### With wget:
```bash
cd FDA_SSED_Documents/

while IFS='|' read -r url filename category; do
    [[ "$url" =~ ^#.*$ ]] && continue
    [[ -z "$url" ]] && continue
    mkdir -p "$category"
    echo "Downloading $filename..."
    wget -q --show-progress -O "$category/$filename" "$url" || echo "Failed: $filename"
done < ssed_urls.txt
```

### With curl:
```bash
cd FDA_SSED_Documents/

while IFS='|' read -r url filename category; do
    [[ "$url" =~ ^#.*$ ]] && continue
    [[ -z "$url" ]] && continue
    mkdir -p "$category"
    echo "Downloading $filename..."
    curl -# -o "$category/$filename" "$url" || echo "Failed: $filename"
done < ssed_urls.txt
```

---

## Method 3: Parallel Download (Faster)

Download multiple files simultaneously using GNU Parallel:

```bash
cd FDA_SSED_Documents/

# Install GNU Parallel if needed (Ubuntu/Debian)
# sudo apt-get install parallel

grep -v '^#' ssed_urls.txt | grep -v '^$' | parallel --colsep '|' \
    'mkdir -p {3} && wget -O {3}/{2} {1}'
```

---

## Method 4: Individual Downloads

Download specific documents manually:

```bash
cd FDA_SSED_Documents/

# Example: Download FoundationOne CDx original SSED
wget -O NGS_Panels/FoundationOne_CDx_P170019_Original_SSED.pdf \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf"

# Example: Download Guardant360 CDx SSED
wget -O Liquid_Biopsy/Guardant360_CDx_P200010_Original_SSED.pdf \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010B.pdf"
```

See README.md files in each subfolder for specific download commands.

---

## Method 5: Browser Download

For environments without command-line tools:

1. Open `ssed_urls.txt` in a text editor
2. Copy each URL (before the | symbol)
3. Paste into your browser
4. Save the downloaded PDF with the suggested filename
5. Move to the appropriate subfolder

---

## Troubleshooting

### Connection Issues

If downloads fail with connection errors:

```bash
# Add retry logic
wget --retry-connrefused --waitretry=5 --read-timeout=60 --timeout=60 -t 5 \
    -O output.pdf "URL"
```

### Proxy Issues

If behind a corporate proxy:

```bash
# Set proxy for wget
export http_proxy=http://proxy.example.com:8080
export https_proxy=http://proxy.example.com:8080

# Set proxy for curl
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

### Slow Downloads

Resume interrupted downloads:

```bash
# wget automatically resumes with -c flag
wget -c -O output.pdf "URL"

# curl can resume with -C flag
curl -C - -o output.pdf "URL"
```

### SSL Certificate Issues

If you encounter SSL errors:

```bash
# wget (use with caution on trusted networks only)
wget --no-check-certificate -O output.pdf "URL"

# curl (use with caution on trusted networks only)
curl -k -o output.pdf "URL"
```

---

## Verification

After downloading, verify your files:

```bash
# Count downloaded PDFs
find . -name "*.pdf" -type f | wc -l
# Expected: ~20 files

# Check total size
du -sh .
# Expected: ~300-500 MB

# List all PDFs with sizes
find . -name "*.pdf" -exec ls -lh {} \; | awk '{print $9, $5}'
```

---

## What Gets Downloaded

### Documents by Category:

**NGS Panels** (5 documents, ~120 MB)
- FoundationOne CDx (3 documents: original + 2 supplements)
- Oncomine Dx Target Test
- TruSight Oncology Comprehensive

**PCR Companion Diagnostics** (2 documents, ~40 MB)
- cobas BRAF V600 (2 documents)

**IHC Companion Diagnostics** (1 document, ~30 MB)
- HercepTest

**FISH Companion Diagnostics** (1 document, ~25 MB)
- PathVysion HER-2

**Liquid Biopsy** (4 documents, ~100 MB)
- Guardant360 CDx (3 documents)
- FoundationOne Liquid CDx

**Colorectal Screening** (1 document, ~35 MB)
- Cologuard Plus

**Digital Pathology** (6 documents, ~80 MB)
- Philips IntelliSite (2 documents)
- Hamamatsu NanoZoomer
- Roche VENTANA DP 200
- Paige Prostate
- Prosigna PAM50

---

## Next Steps

After downloading:

1. Review the main README.md in each folder for device information
2. Check the comprehensive device list: `FDA_Oncology_Molecular_Diagnostics_Digital_Pathology_Devices.txt`
3. For additional supplements not included in automatic downloads, visit FDA PMA database directly

---

## FDA Resources

- **PMA Database**: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPMA/pma.cfm
- **510(k) Database**: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpmn/pmn.cfm
- **Companion Diagnostics List**: https://www.fda.gov/medical-devices/in-vitro-diagnostics/list-cleared-or-approved-companion-diagnostic-devices-in-vitro-and-imaging-tools

---

## Support

For issues or questions:
- Check README.md files in each subfolder
- Search FDA PMA/510(k) databases using device PMA/510(k) numbers
- Contact device manufacturers for proprietary documents

**Last Updated**: December 4, 2025
