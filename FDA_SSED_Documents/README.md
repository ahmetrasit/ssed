# FDA SSED Documents Collection

This folder contains organized subfolders for all SSED (Summary of Safety and Effectiveness Data) and regulatory summary documents for FDA-authorized oncology molecular diagnostics and digital pathology devices.

## Folder Structure

```
FDA_SSED_Documents/
├── NGS_Panels/                      # Next-Generation Sequencing Panels
├── PCR_Companion_Diagnostics/       # PCR-based Companion Diagnostics
├── IHC_Companion_Diagnostics/       # Immunohistochemistry Companion Diagnostics
├── FISH_Companion_Diagnostics/      # FISH Probe Companion Diagnostics
├── Liquid_Biopsy/                   # Liquid Biopsy Tests (cfDNA)
├── Colorectal_Screening/            # Colorectal Cancer Screening Tests
└── Digital_Pathology_Systems/       # Digital Pathology and AI Systems
```

## How to Download Documents

Due to network restrictions, documents cannot be automatically downloaded. Each subfolder contains a README.md file with:

1. Complete list of all SSED and summary documents
2. Direct FDA download links
3. Device information (PMA/510(k) numbers, approval dates)
4. Instructions for manual download

### Download Methods

**Option 1: Direct Browser Download**
- Open the links in a web browser
- Right-click and "Save As" to download PDFs

**Option 2: Command Line (if you have direct FDA access)**
```bash
# Example using wget
wget -O filename.pdf "URL"

# Example using curl
curl -o filename.pdf "URL"
```

**Option 3: FDA FOIA (Freedom of Information Act)**
- For documents not publicly available online
- Submit request at: https://www.fda.gov/regulatory-information/freedom-information

## Document Types

### SSED (Summary of Safety and Effectiveness Data)
- Required for PMA (Premarket Approval) Class III devices
- Contains detailed clinical and analytical validation data
- Typical format: P######B.pdf or P######S###B.pdf

### 510(k) Summaries
- Required for 510(k) cleared Class II devices
- Contains substantial equivalence information
- Typical format: K######.pdf

### De Novo Decision Summaries
- For novel devices that establish new regulatory classifications
- Contains detailed rationale for classification
- Typical format: DEN######.pdf

## Total Documents Available

Based on the comprehensive device list:
- **NGS Panels**: 12+ documents (PMAs with multiple supplements)
- **PCR Companion Diagnostics**: 6+ documents
- **IHC Companion Diagnostics**: 8+ documents
- **FISH Companion Diagnostics**: 4+ documents
- **Liquid Biopsy**: 6+ documents
- **Colorectal Screening**: 4+ documents
- **Digital Pathology Systems**: 8+ documents

**Total: 48+ regulatory documents**

## FDA Resources

### Primary Databases
- **PMA Database**: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPMA/pma.cfm
- **510(k) Database**: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfpmn/pmn.cfm
- **CDRH Documents**: https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPMN/pmn.cfm

### Search Tips
1. Use PMA/510(k) numbers to find specific devices
2. Look for "SSED" or "Summary" buttons on device pages
3. Check "Supplements" section for additional documents
4. Download both original approvals and all supplements

## Notes for Regulatory Professionals

- **PMA Supplements**: Listed as separate documents (e.g., P170019/S048)
- **Naming Convention**: Files named by device and PMA/supplement number
- **File Sizes**: SSEDs typically range from 5MB to 50MB
- **Format**: All documents are PDF format

## Updates

This collection is current as of December 4, 2025. For the most recent approvals:
- Check FDA Oncology Center of Excellence: https://www.fda.gov/about-fda/oncology-center-excellence
- Monitor FDA CDRH News: https://www.fda.gov/medical-devices/medical-devices-news-and-events

---

For questions or issues accessing documents, consult the README.md file in each subfolder for specific device information and alternative download methods.
