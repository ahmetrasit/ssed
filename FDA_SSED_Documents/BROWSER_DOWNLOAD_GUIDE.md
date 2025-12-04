# Browser Download Guide - For Restricted Network Environments

## Issue
This environment's proxy blocks `accessdata.fda.gov`, but you can access it through your browser.

## Solution: Download via Browser

### Option 1: Manual Downloads (Simple)

Open these URLs in your browser and save the PDFs:

#### NGS Panels
```
https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf
  → Save as: NGS_Panels/FoundationOne_CDx_P170019_Original_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S029B.pdf
  → Save as: NGS_Panels/FoundationOne_CDx_P170019_S029_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S048B.pdf
  → Save as: NGS_Panels/FoundationOne_CDx_P170019_S048_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf16/p160045b.pdf
  → Save as: NGS_Panels/Oncomine_Dx_Target_P160045_Original_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230011C.pdf
  → Save as: NGS_Panels/TruSight_Oncology_Comprehensive_P230011_Technical_Info.pdf
```

#### PCR Companion Diagnostics
```
https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020b.pdf
  → Save as: PCR_Companion_Diagnostics/cobas_4800_BRAF_V600_P110020_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020c.pdf
  → Save as: PCR_Companion_Diagnostics/cobas_4800_BRAF_V600_P110020_Technical_Info.pdf
```

#### IHC Companion Diagnostics
```
https://www.accessdata.fda.gov/cdrh_docs/pdf/P980018S010b.pdf
  → Save as: IHC_Companion_Diagnostics/HercepTest_P980018_S010_SSED.pdf
```

#### FISH Companion Diagnostics
```
https://www.accessdata.fda.gov/cdrh_docs/pdf/P980024S001c.pdf
  → Save as: FISH_Companion_Diagnostics/PathVysion_HER2_P980024_S001_Technical_Info.pdf
```

#### Liquid Biopsy
```
https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010B.pdf
  → Save as: Liquid_Biopsy/Guardant360_CDx_P200010_Original_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S008C.pdf
  → Save as: Liquid_Biopsy/Guardant360_CDx_P200010_S008_Technical_Info.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S010B.pdf
  → Save as: Liquid_Biopsy/Guardant360_CDx_P200010_S010_SSED.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf19/P190032C.pdf
  → Save as: Liquid_Biopsy/FoundationOne_Liquid_CDx_P190032_Technical_Info.pdf
```

#### Colorectal Screening
```
https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230043B.pdf
  → Save as: Colorectal_Screening/Cologuard_Plus_P230043_SSED.pdf
```

#### Digital Pathology Systems
```
https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN160056.pdf
  → Save as: Digital_Pathology_Systems/Philips_IntelliSite_DEN160056_De_Novo_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/pdf16/DEN160056.pdf
  → Save as: Digital_Pathology_Systems/Philips_IntelliSite_DEN160056_Decision_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/K213883.pdf
  → Save as: Digital_Pathology_Systems/Hamamatsu_NanoZoomer_S360MD_K213883_510k_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/K232879.pdf
  → Save as: Digital_Pathology_Systems/Roche_VENTANA_DP200_K232879_510k_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN200080.pdf
  → Save as: Digital_Pathology_Systems/Paige_Prostate_DEN200080_De_Novo_Summary.pdf

https://www.accessdata.fda.gov/cdrh_docs/reviews/k130010.pdf
  → Save as: Digital_Pathology_Systems/Prosigna_PAM50_K130010_510k_Summary.pdf
```

---

### Option 2: Browser Extension (Batch Download)

Use a browser extension like:
- **DownThemAll** (Firefox, Chrome)
- **Chrono Download Manager** (Chrome)

Steps:
1. Copy all URLs from `ssed_urls.txt`
2. Paste into download manager
3. Set download folder structure
4. Start batch download

---

### Option 3: Generate wget/curl Commands On Your Local Machine

On your LOCAL computer (not in this container):

1. Clone the repository to your local machine:
   ```bash
   git clone <your-repo-url>
   cd ssed/FDA_SSED_Documents/
   ```

2. Run the download script locally:
   ```bash
   chmod +x download_all_sseds.sh
   ./download_all_sseds.sh
   ```

3. Commit and push the downloaded PDFs:
   ```bash
   git add .
   git commit -m "Add downloaded SSED documents"
   git push
   ```

---

### Option 4: Download Manager Software

Use dedicated download managers:
- **JDownloader** (cross-platform)
- **Free Download Manager**
- **aria2** (command line, very fast)

Import URLs from `ssed_urls.txt`

---

## After Downloading

Once you have the PDFs on your local machine:

### Upload to Repository
```bash
# Copy files to appropriate folders
# Commit and push
git add FDA_SSED_Documents/
git commit -m "Add SSED PDF documents"
git push
```

### Or Use Cloud Storage
If PDFs are too large for git:
- Upload to Google Drive / Dropbox
- Share link in repository README
- Use Git LFS for large files

---

## Why This Happens

**Container Environment:**
- Runs with restricted proxy
- Only whitelisted domains allowed (GitHub, npm, PyPI, etc.)
- FDA domains NOT in whitelist

**Your Browser:**
- Runs on your local machine
- No proxy restrictions
- Direct internet access

**Solution:**
Download on your local machine, then upload to repository or cloud storage.

---

## Quick Reference - All 20 URLs

```
https://www.accessdata.fda.gov/cdrh_docs/pdf17/p170019b.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S029B.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf17/P170019S048B.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf16/p160045b.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230011C.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020b.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020c.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf/P980018S010b.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf/P980024S001c.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010B.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S008C.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf20/P200010S010B.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf19/P190032C.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf23/P230043B.pdf
https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN160056.pdf
https://www.accessdata.fda.gov/cdrh_docs/pdf16/DEN160056.pdf
https://www.accessdata.fda.gov/cdrh_docs/reviews/K213883.pdf
https://www.accessdata.fda.gov/cdrh_docs/reviews/K232879.pdf
https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN200080.pdf
https://www.accessdata.fda.gov/cdrh_docs/reviews/k130010.pdf
```

**Total:** 20 documents, approximately 500 MB

---

## Need Help?

1. Check if URLs are accessible in your browser first
2. Try downloading 1-2 files manually to test
3. Use browser developer tools (F12) to see if downloads succeed
4. Consider Git LFS if files are too large for standard git

