# PCR-Based Companion Diagnostics - SSED Documents

This folder contains SSED and technical information documents for FDA-approved PCR-based companion diagnostic tests used in oncology.

---

## 1. COBAS EGFR MUTATION TEST v2

**Manufacturer**: Roche Molecular Systems, Inc.
**Original PMA**: P150044
**Approval Date**: June 1, 2016 (Priority Review)
**Device Class**: III

### Documents to Download:

#### SSED/Technical Documents
- **File**: `cobas_EGFR_v2_P150044_SSED.pdf`
- **URL**: Search FDA PMA database at https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=P150044
- **Description**: Real-time PCR test for 42 EGFR mutations in NSCLC
- **Size**: ~20-30 MB

#### Additional Resources
- **FDA Device Page**: https://www.fda.gov/drugs/resources-information-approved-drugs/cobas-egfr-mutation-test-v2
- **FDA PMA Page**: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=P150044

**Note**: First companion diagnostic to receive therapeutic class labeling

---

## 2. COBAS 4800 BRAF V600 MUTATION TEST

**Manufacturer**: Roche Molecular Diagnostics
**Original PMA**: P110020
**Approval Date**: 2011
**Device Class**: III

### Documents to Download:

#### Original Approval
- **File**: `cobas_4800_BRAF_V600_P110020_SSED.pdf`
- **URL**: https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020b.pdf
- **Description**: SSED for BRAF V600 mutation detection in melanoma
- **Size**: ~25 MB

#### Technical Information
- **File**: `cobas_4800_BRAF_V600_P110020_Technical_Info.pdf`
- **URL**: https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020c.pdf
- **Description**: Technical specifications and validation data
- **Size**: ~15 MB

#### Additional Resources
- **FDA PMA Page**: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpma/pma.cfm?id=P110020S016
- **Product Page**: https://diagnostics.roche.com/us/en/products/lab/cobas-4800-braf-v600-mutation-test-rmd-4800-braf-002.html

---

## 3. THERASCREEN KRAS RGQ PCR KIT

**Manufacturer**: QIAGEN GmbH / QIAGEN Manchester, Ltd.
**Approval Date**: May 2014 (second colorectal drug pairing)
**Device Class**: III

### Documents to Download:

**Note**: Search FDA PMA database using "therascreen KRAS" or QIAGEN

#### Additional Resources
- **Product Information**: https://www.qiagen.com/us/products/diagnostics-and-clinical-research/oncology/therascreen-solid-tumor/therascreen-kras-rgq-pcr-kit-us
- **Press Release**: https://www.prnewswire.com/news-releases/qiagen-receives-fda-approval-of-therascreen-kras-rgq-pcr-kit-paired-with-second-colorectal-cancer-drug-260468421.html

**Features**:
- Detects 7 KRAS mutations in codons 12 and 13
- Workflow: ~8 hours
- Used for LUMAKRAS (sotorasib) and KRAZATI (adagrasib) CDx

---

## Download Instructions

### Method 1: FDA PMA Database Search
1. Go to: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPMA/pma.cfm
2. Enter PMA number (e.g., P150044, P110020)
3. Click "SSED" button to download
4. Look for supplements list

### Method 2: Direct Browser Download
1. Click on the URLs provided above
2. Your browser should download the PDF automatically
3. Save with the suggested filename in this folder

### Method 3: Command Line (with proper network access)
```bash
cd FDA_SSED_Documents/PCR_Companion_Diagnostics/

# cobas EGFR v2
wget -O cobas_EGFR_v2_P150044_SSED.pdf "[URL from FDA database]"

# cobas BRAF V600
wget -O cobas_4800_BRAF_V600_P110020_SSED.pdf "https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020b.pdf"
wget -O cobas_4800_BRAF_V600_P110020_Technical_Info.pdf "https://www.accessdata.fda.gov/cdrh_docs/pdf11/P110020c.pdf"

# therascreen KRAS
# Search FDA database for specific PMA number and download
```

---

## Summary

**Total Documents**: 3+ main SSEDs
**Estimated Total Size**: ~70 MB
**Document Types**: SSED, Technical Information
**Format**: PDF

These PCR-based assays represent critical companion diagnostics for targeted cancer therapies in NSCLC, melanoma, and colorectal cancer.
