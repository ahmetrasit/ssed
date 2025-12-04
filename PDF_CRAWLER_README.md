# PDF Crawler - Web Crawler for Extracting PDF Links

A Python-based web crawler that systematically visits all pages on a website and extracts links to PDF files. Perfect for discovering all FDA SSED documents, supplement PDFs, or any other PDF resources on a website.

## Features

- **Comprehensive Crawling**: Visits all pages on a website within the same domain
- **PDF Detection**: Automatically identifies and extracts PDF file links
- **Resume Support**: Save crawler state and resume interrupted crawls
- **Rate Limiting**: Respectful delays between requests to avoid overwhelming servers
- **Progress Tracking**: Real-time progress display with statistics
- **Error Handling**: Gracefully handles network errors and continues crawling
- **Flexible Output**: Saves all PDF links to a text file with metadata

## Installation

### Prerequisites

```bash
# Python 3.6 or higher required
python3 --version

# Install required packages
pip3 install requests beautifulsoup4
```

### Quick Start

```bash
# Make script executable
chmod +x pdf_crawler.py

# Basic usage
python3 pdf_crawler.py "https://example.com"

# With options
python3 pdf_crawler.py "https://example.com" --max-pages 100 --output my_pdfs.txt
```

## Usage Examples

### 1. Crawl FDA PMA Page for All PDFs

```bash
# FoundationOne CDx (P170019)
python3 pdf_crawler.py "https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=P170019" \
    --max-pages 100 \
    --output foundationone_pdfs.txt

# Guardant360 CDx (P200010)
python3 pdf_crawler.py "https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=P200010" \
    --max-pages 100 \
    --output guardant360_pdfs.txt
```

### 2. Using the Convenience Script

```bash
chmod +x crawl_fda_pdfs.sh

# Automatically crawl any PMA device
./crawl_fda_pdfs.sh P170019  # FoundationOne CDx
./crawl_fda_pdfs.sh P200010  # Guardant360 CDx
./crawl_fda_pdfs.sh P160045  # Oncomine Dx Target
```

### 3. Resume Interrupted Crawl

```bash
# Start crawling
python3 pdf_crawler.py "https://example.com" --output pdfs.txt

# If interrupted (Ctrl+C), resume with:
python3 pdf_crawler.py "https://example.com" --resume --output pdfs.txt
```

### 4. Crawl Multiple Domains

```bash
# Allow external domains (default is same-domain only)
python3 pdf_crawler.py "https://example.com" --allow-external --max-pages 500
```

### 5. Faster Crawling

```bash
# Reduce delay between requests (use responsibly!)
python3 pdf_crawler.py "https://example.com" --delay 0.5 --max-pages 1000
```

## Command-Line Options

```
usage: pdf_crawler.py [-h] [--max-pages MAX_PAGES] [--delay DELAY]
                      [--output OUTPUT] [--resume]
                      [--resume-file RESUME_FILE] [--allow-external]
                      url

positional arguments:
  url                   Starting URL to crawl

optional arguments:
  -h, --help            Show help message
  --max-pages MAX_PAGES Maximum number of pages to crawl (default: 200)
  --delay DELAY         Delay between requests in seconds (default: 1.0)
  --output OUTPUT       Output file for PDF links (default: pdf_links.txt)
  --resume              Resume from previous crawl state
  --resume-file FILE    State file for resuming (default: crawler_state.json)
  --allow-external      Allow crawling external domains
```

## Output Format

The crawler generates a text file with all discovered PDF links:

```
# PDF Links extracted from: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=P170019
# Total PDFs found: 87
# Pages crawled: 45
# Generated: 2025-12-04 15:30:45

https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S002B.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S002C.pdf
...
```

## State Files

The crawler automatically saves its state to `crawler_state.json`:

```json
{
  "visited_urls": [...],
  "pdf_links": [...],
  "to_visit": [...],
  "pages_crawled": 45
}
```

This allows you to:
- Resume interrupted crawls
- Track progress
- Debug crawling issues

## Real-World Use Cases

### 1. Extract All FDA SSED Documents for a Device

```bash
# Get all supplement SSEDs for FoundationOne CDx
./crawl_fda_pdfs.sh P170019

# Result: fda_pdfs_P170019.txt with ~50-100 PDF links
# Including original SSED and all supplement SSEDs
```

### 2. Batch Crawl Multiple Devices

```bash
# Create a batch script
cat > crawl_all_devices.sh << 'EOF'
#!/bin/bash
for PMA in P170019 P200010 P160045 P190032 P240010; do
    echo "Crawling $PMA..."
    ./crawl_fda_pdfs.sh "$PMA"
    sleep 5  # Delay between devices
done
EOF

chmod +x crawl_all_devices.sh
./crawl_all_devices.sh
```

### 3. Find All PDFs on FDA Product Code Page

```bash
# Crawl PQP product code search results
python3 pdf_crawler.py \
    "https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPMA/pma.cfm?start_search=1&productcode=PQP" \
    --max-pages 500 \
    --output pqp_all_pdfs.txt \
    --delay 1.5
```

## Performance & Best Practices

### Recommended Settings

- **Delay**: 1.0 seconds (respectful to server)
- **Max Pages**: 100-200 for single device, 500+ for comprehensive crawls
- **Same Domain**: Keep enabled for focused crawling

### FDA-Specific Tips

1. **PMA Pages**: Each PMA device page typically links to 10-50 PDFs
2. **Supplements**: Crawling from the main PMA page discovers supplement links
3. **Success Rate**: Expect to find 60-80% of supplements with public SSEDs
4. **Crawl Time**: ~2-5 minutes per device (100 pages @ 1 request/sec)

### Rate Limiting

```bash
# Conservative (recommended for FDA)
--delay 1.5

# Moderate
--delay 1.0

# Aggressive (use only if necessary)
--delay 0.5
```

## Troubleshooting

### Package Installation Issues

```bash
# If pip3 fails, try:
python3 -m pip install --user requests beautifulsoup4

# Or use system package manager:
sudo apt-get install python3-requests python3-bs4  # Debian/Ubuntu
brew install python3  # Mac
```

### Network Errors

The crawler automatically handles:
- Timeouts (30 seconds)
- Connection errors
- HTTP errors (404, 403, etc.)

### Resume Not Working

```bash
# Check if state file exists
ls -lh crawler_state.json

# Manually specify state file
python3 pdf_crawler.py "URL" --resume-file my_state.json --resume
```

## Advanced Usage

### Custom Filtering

Modify the `is_pdf_link()` function to customize PDF detection:

```python
def is_pdf_link(self, url):
    """Custom PDF detection"""
    parsed = urlparse(url)
    path = parsed.path.lower()

    # Only SSEDs (exclude technical info)
    if 'pdf' in path and 'b.pdf' in path.lower():
        return True

    return False
```

### Integration with Download Scripts

```bash
# 1. Crawl for PDFs
python3 pdf_crawler.py "URL" --output discovered_pdfs.txt

# 2. Convert to ssed_urls.txt format
awk '{if (!/^#/) print $0"|"FILENAME"|NGS_Panels"}' discovered_pdfs.txt > new_ssed_urls.txt

# 3. Download with aria2
./download_with_aria2_comprehensive.sh
```

## Comparison with Alternative Methods

| Method | Pros | Cons |
|--------|------|------|
| **PDF Crawler** | Automated, comprehensive, finds all PDFs | Requires Python, time-consuming |
| **Manual browsing** | No setup | Tedious, error-prone, incomplete |
| **Browser extensions** | User-friendly | Limited to visible links, no automation |
| **wget recursive** | Simple | No PDF filtering, downloads everything |

## Contributing

Found a bug or have a feature request? The crawler is designed to be extensible:

1. Add custom link filters
2. Implement different output formats (JSON, CSV)
3. Add support for authentication
4. Integrate with download managers

## License

This script is provided as-is for educational and research purposes. When crawling websites:
- Respect robots.txt
- Use reasonable delays
- Don't overwhelm servers
- Comply with website terms of service

## Credits

Created for systematic extraction of FDA SSED documents and regulatory information from the FDA PMA database.

---

**Last Updated**: December 4, 2025
**Version**: 1.0
