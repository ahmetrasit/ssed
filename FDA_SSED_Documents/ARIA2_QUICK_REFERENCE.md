# aria2c Quick Reference for FDA SSED Downloads

## What is aria2?

**aria2** is a lightweight, ultra-fast download utility that:
- ✅ Uses **16 connections per file** (vs. wget's 1)
- ✅ Downloads **4 files in parallel**
- ✅ Automatically resumes broken downloads
- ✅ ~**5-10x faster** than wget
- ✅ Works on Linux, Mac, Windows

**Speed comparison:**
- wget: ~10 minutes for all files
- aria2c: ~2-3 minutes for all files

---

## Installation

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install aria2
```

### Mac
```bash
brew install aria2
```

### Windows
1. Download from: https://aria2.github.io/
2. Extract to `C:\aria2\`
3. Add to PATH or run from folder

---

## Method 1: Automated Script (Recommended)

The easiest way - full automation:

```bash
cd FDA_SSED_Documents/
./download_with_aria2.sh
```

**What it does:**
- Creates folder structure automatically
- Downloads all 20 files with optimal settings
- Shows progress and summary
- Takes ~2-3 minutes

---

## Method 2: Manual aria2 Commands

### Basic Download (single file)
```bash
aria2c -x 16 -s 16 \
    -d NGS_Panels \
    -o FoundationOne_CDx_P170019_Original_SSED.pdf \
    "https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf"
```

**Flags explained:**
- `-x 16`: Use 16 connections per server
- `-s 16`: Split file into 16 parts
- `-d`: Output directory
- `-o`: Output filename

### Batch Download from URL List
```bash
# First, create input file (already done: aria2_input.txt)
aria2c -i aria2_input.txt -x 16 -s 16 -j 4
```

**Additional flags:**
- `-j 4`: Download 4 files concurrently
- `-c`: Continue/resume download
- `--max-tries=5`: Retry failed downloads

### Maximum Speed Configuration
```bash
aria2c \
    -i aria2_input.txt \
    -x 16 \
    -s 16 \
    -j 8 \
    --min-split-size=1M \
    --max-connection-per-server=16 \
    --max-concurrent-downloads=8 \
    --continue=true \
    --max-tries=10 \
    --retry-wait=3
```

---

## Method 3: One-Liner from ssed_urls.txt

Convert URL list and download:

```bash
# Create aria2 input on-the-fly and download
while IFS='|' read -r url filename category; do
    [[ "$url" =~ ^#.*$ ]] && continue
    [[ -z "$url" ]] && continue
    mkdir -p "$category"
    aria2c -x 16 -s 16 -d "$category" -o "$filename" "$url"
done < ssed_urls.txt
```

---

## Method 4: Parallel with Maximum Speed

For the absolute fastest download:

```bash
# Download 8 files at once, each with 16 connections
cat ssed_urls.txt | grep -v '^#' | grep -v '^$' | \
    awk -F'|' '{print $1"\n  dir="$3"\n  out="$2}' > aria2_batch.txt

aria2c -i aria2_batch.txt \
    -x 16 \
    -s 16 \
    -j 8 \
    --file-allocation=none \
    --max-connection-per-server=16
```

**Speed:** ~90 seconds for all files! ⚡

---

## Configuration File (Optional)

Create `~/.aria2/aria2.conf` for permanent settings:

```ini
# ~/.aria2/aria2.conf
max-connection-per-server=16
split=16
max-concurrent-downloads=4
min-split-size=1M
continue=true
max-tries=5
retry-wait=3
timeout=60
connect-timeout=30
```

Then simply run:
```bash
aria2c -i aria2_input.txt
```

---

## Advanced Options

### Download with Bandwidth Limit
```bash
aria2c -i aria2_input.txt --max-download-limit=5M
```

### Download with Proxy
```bash
aria2c -i aria2_input.txt --all-proxy="http://proxy.example.com:8080"
```

### Download with Authentication
```bash
aria2c --http-user=username --http-passwd=password \
    "https://example.com/file.pdf"
```

### Check File Integrity (with checksums)
```bash
aria2c --checksum=sha-256=<hash> "https://example.com/file.pdf"
```

---

## Monitoring & Progress

### Summary Every 10 Seconds
```bash
aria2c -i aria2_input.txt --summary-interval=10
```

### Quiet Mode (minimal output)
```bash
aria2c -i aria2_input.txt --console-log-level=error
```

### Full Statistics After Download
```bash
aria2c -i aria2_input.txt --download-result=full
```

---

## Resume Broken Downloads

aria2c automatically resumes by default:

```bash
# If download was interrupted, just run again:
aria2c -i aria2_input.txt --continue=true
```

aria2 saves `.aria2` control files for resuming.

---

## Troubleshooting

### "File already exists" Error
```bash
# Force overwrite
aria2c --allow-overwrite=true -i aria2_input.txt

# Or delete .aria2 control files
find . -name "*.aria2" -delete
```

### Connection Timeout
```bash
# Increase timeout values
aria2c -i aria2_input.txt \
    --timeout=120 \
    --connect-timeout=60 \
    --max-tries=10
```

### SSL/Certificate Errors
```bash
# Disable certificate check (use cautiously)
aria2c --check-certificate=false -i aria2_input.txt
```

---

## Comparison with Other Tools

| Tool | Speed | Connections | Resume | Cross-platform |
|------|-------|-------------|--------|----------------|
| **aria2c** | ⚡⚡⚡⚡⚡ | 16 per file | ✅ | ✅ |
| wget | ⚡⚡ | 1 per file | ✅ | ✅ |
| curl | ⚡⚡ | 1 per file | ✅ | ✅ |
| browser | ⚡⚡⚡ | varies | ✅ | ✅ |

---

## Complete Example Workflow

```bash
# 1. Navigate to directory
cd FDA_SSED_Documents/

# 2. Create directories
mkdir -p {NGS_Panels,PCR_Companion_Diagnostics,IHC_Companion_Diagnostics,FISH_Companion_Diagnostics,Liquid_Biopsy,Colorectal_Screening,Digital_Pathology_Systems}

# 3. Download with aria2c (fastest method)
aria2c -i aria2_input.txt -x 16 -s 16 -j 4

# 4. Verify downloads
find . -name "*.pdf" | wc -l  # Should be 20

# 5. Check sizes
du -sh */

# 6. Commit to git
git add .
git commit -m "Add FDA SSED documents via aria2"
git push
```

**Total time:** ~3-5 minutes including verification! 🚀

---

## Pro Tips

💡 **Fastest download:** Use `-j 8` to download 8 files at once

💡 **Resume anytime:** Just run the same command again - aria2 auto-resumes

💡 **Low memory?** Add `--file-allocation=none` to skip pre-allocation

💡 **Slow connection?** Reduce to `-x 4 -s 4` for fewer connections

💡 **Behind proxy?** Add `--all-proxy="http://proxy:port"`

💡 **Want logs?** Add `--log=download.log` for debugging

---

## Need Help?

```bash
# Show all options
aria2c --help

# Show version
aria2c --version

# Test single download
aria2c --dry-run "https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf"
```

Official documentation: https://aria2.github.io/manual/en/html/

---

## Summary

**Recommended command for FDA SSED downloads:**

```bash
./download_with_aria2.sh
```

Or manually:

```bash
aria2c -i aria2_input.txt -x 16 -s 16 -j 4 --continue=true --max-tries=5
```

**Result:** All 20 documents downloaded in ~2-3 minutes! ⚡
