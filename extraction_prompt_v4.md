# SSED Extraction Prompt - Framework v4.3

## Overview

You are extracting structured data from an FDA Summary of Safety and Effectiveness Data (SSED) document for a companion diagnostic (CDx) device. Extract data into standardized subsection sheets as defined below.

## Critical Extraction Principle

**ALWAYS make your best effort to categorize information into the defined sheets.** The uncategorized sheet (99_uncategorized) is a LAST RESORT, not a shortcut. Before placing any content in the uncategorized sheet:

1. **Re-read the sheet definitions** to ensure the content doesn't fit an existing category
2. **Consider related sheets** - information may belong to a similar category
3. **Use your judgment** - if content is 70%+ related to a sheet, include it there with appropriate source_summary
4. **Only use uncategorized** when content truly has no appropriate home in the schema

Excessive use of the uncategorized sheet indicates incomplete extraction and is not acceptable.

## Output Format

Return a single JSON object with the following structure:

```json
{
  "_metadata": {
    "submission_number": "P######",
    "device_name": "Device Name",
    "extraction_date": "YYYY-MM-DD",
    "source_document": "filename.pdf",
    "framework_version": "4.3.0",
    "sheets_extracted": ["1.1_device_name_and_classification", "2.1_intended_use_statement", ...]
  },
  "1.1_device_name_and_classification": { ... },
  "2.1_intended_use_statement": { ... },
  "4.3.2_limit_of_detection": [ ... ],
  ...
}
```

## Extraction Rules

### Full-Text Sheets (Verbatim Extraction)
The following sheets require **verbatim text** from the SSED. Do NOT summarize:
- `2.1_intended_use_statement` - Copy the exact intended use statement
- `10.1_warnings_and_precautions` - Copy all warnings and precautions verbatim
- `10.2_contraindications` - Copy all contraindications verbatim

### Summary Sheets (All Others)
All other sheets MUST include a `source_summary` column containing a brief summary of the source paragraph(s) from which the row data was extracted. This enables traceability.

### Cardinality
- **single**: Sheet contains exactly one row (output as object)
- **multiple**: Sheet contains multiple rows (output as array of objects)

---

## Sheet Definitions

### 1. Device Information

#### 1.1_device_name_and_classification (single)
Extract from SSED Section I.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| proprietary_name | string | yes | Trade name of the device |
| established_name | string | yes | Generic/established name |
| common_name | string | no | Common name if different |
| device_class | string | yes | "II" or "III" |
| product_code | string | yes | FDA product code |
| regulation_number | string | no | 21 CFR regulation number |
| submission_type | string | yes | "PMA", "PMA_supplement", "510(k)", or "De Novo" |
| submission_number | string | yes | e.g., P210040B |
| approval_date | date | yes | YYYY-MM-DD format |

#### 1.2_manufacturer_information (single)
Extract from SSED Section I.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| manufacturer_name | string | yes | Company name |
| manufacturer_address | string | yes | Full address |
| facility_registration | string | no | FDA registration number |
| contact_person | string | no | Contact name |
| contact_phone | string | no | Phone number |

#### 1.3_device_description (single)
Extract from SSED Sections I and V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| technology_platform | string | yes | e.g., "NGS", "PCR", "IHC" |
| detection_method | string | yes | e.g., "targeted sequencing", "real-time PCR" |
| automation_level | string | no | "manual", "semi-automated", or "fully-automated" |
| testing_location | string | yes | "CLIA-certified laboratory", "point-of-care", or "home-use" |
| single_site_or_distributed | string | no | "single-site" or "distributed" |

---

### 2. Indications for Use

#### 2.1_intended_use_statement (single) - FULL TEXT
Extract VERBATIM from SSED Section II.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| intended_use_text | string | yes | **VERBATIM** intended use statement |
| qualitative_quantitative | string | yes | "qualitative", "quantitative", or "semi-quantitative" |

#### 2.2_target_biomarkers (multiple)
Extract from SSED Section II. One row per biomarker.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| biomarker_name | string | yes | e.g., "EGFR L858R" |
| biomarker_type | string | yes | "gene", "mutation", "protein", "fusion", "amplification", "expression", "methylation" |
| gene_symbol | string | no | e.g., "EGFR", "KRAS" |
| variant_type | string | no | "SNV", "indel", "CNV", "fusion", "structural", "all" |
| specific_variants | string | no | Comma-separated list if multiple |
| cdx_category | string | yes | "CDx_Level1", "analytical_only", or "tumor_profiling" |
| clinical_significance | string | yes | Summary of clinical significance |
| source_summary | string | yes | Summary of source paragraph |

#### 2.3_associated_therapeutics (multiple)
Extract CDx claims from SSED Section II. One row per drug-biomarker pair.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| therapeutic_name | string | yes | Drug name (generic or brand) |
| therapeutic_manufacturer | string | no | Pharma company |
| therapeutic_nda_bla | string | no | NDA/BLA number |
| therapeutic_class | string | no | Drug class |
| mechanism_of_action | string | no | MOA description |
| approved_indication | string | yes | FDA-approved indication |
| cancer_type | string | yes | e.g., "NSCLC", "CRC" |
| line_of_therapy | string | no | e.g., "first-line", "second-line" |
| biomarker_tested | string | yes | Which biomarker the drug is linked to |
| cdx_labeling_requirement | string | yes | "required", "recommended", or "informational" |
| therapeutic_approval_date | date | no | YYYY-MM-DD |
| source_summary | string | yes | Summary of source paragraph |

#### 2.4_patient_population (single)
Extract from SSED Section II.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| disease_condition | string | yes | e.g., "non-small cell lung cancer" |
| disease_stage | string | no | e.g., "metastatic", "stage III/IV" |
| histology | string | no | e.g., "adenocarcinoma" |
| prior_therapy_status | string | no | e.g., "previously treated" |
| age_range | string | no | e.g., "adults 18+" |
| excluded_populations | string | no | Comma-separated list |
| source_summary | string | yes | Summary of source paragraph |

---

### 3. Specimen Requirements

#### 3.1_approved_specimen_types (multiple)
Extract from SSED Section V. One row per specimen type.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| specimen_type | string | yes | e.g., "FFPE tissue", "plasma" |
| collection_method | string | yes | e.g., "biopsy", "blood draw" |
| collection_container | string | no | Tube/container type |
| preservative | string | no | e.g., "formalin-fixed" |
| minimum_volume | number | no | Minimum required |
| optimal_volume | number | no | Optimal amount |
| volume_unit | string | no | e.g., "mL", "slides" |
| minimum_tumor_content_percent | number | no | Minimum tumor % |
| minimum_nucleic_acid_input_ng | number | no | Minimum DNA/RNA input |
| source_summary | string | yes | Summary of source paragraph |

#### 3.2_specimen_stability (multiple)
Extract from SSED Sections V and IX.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| specimen_type | string | yes | Specimen type |
| storage_condition | string | yes | e.g., "room temperature", "frozen" |
| temperature_min_c | number | no | Min temperature in Celsius |
| temperature_max_c | number | no | Max temperature in Celsius |
| stability_duration | string | yes | e.g., "7 days", "6 months" |
| stability_duration_hours | number | no | Duration in hours |
| freeze_thaw_cycles | integer | no | Number allowed |
| source_summary | string | yes | Summary of source paragraph |

#### 3.3_rejection_criteria (multiple)
Extract from SSED Section V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| criterion | string | yes | The rejection criterion |
| criterion_category | string | no | "volume", "quality", "labeling", "transport", "contamination", "other" |
| source_summary | string | yes | Summary of source paragraph |

---

### 4. Analytical Performance

#### 4.1_accuracy_concordance (multiple)
Extract from SSED Section IX.A. One row per biomarker/reference method.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| target_biomarker | string | yes | Biomarker tested |
| reference_method | string | yes | Comparator method |
| specimen_type | string | no | Specimen used |
| n_positive_samples | integer | yes | Number positive |
| n_negative_samples | integer | yes | Number negative |
| n_total_samples | integer | no | Total samples |
| ppa_value | number | yes | Positive percent agreement (0-100) |
| ppa_ci_lower | number | yes | PPA 95% CI lower bound |
| ppa_ci_upper | number | yes | PPA 95% CI upper bound |
| npa_value | number | yes | Negative percent agreement (0-100) |
| npa_ci_lower | number | yes | NPA 95% CI lower bound |
| npa_ci_upper | number | yes | NPA 95% CI upper bound |
| opa_value | number | no | Overall percent agreement |
| discordant_count | integer | no | Number discordant |
| discordant_analysis | string | no | Analysis of discordants |
| source_summary | string | yes | Summary of source paragraph |

#### 4.2.1_repeatability (multiple)
Extract within-run precision from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| target_biomarker | string | yes | Biomarker tested |
| sample_id | string | no | Sample identifier |
| sample_level | string | yes | e.g., "low positive", "high positive", "negative" |
| target_vaf_percent | number | no | Target VAF % |
| n_replicates | integer | yes | Number of replicates |
| n_detected | integer | no | Number detected |
| agreement_rate_percent | number | no | Agreement rate |
| mean_value | number | no | Mean measurement |
| sd | number | no | Standard deviation |
| cv_percent | number | no | Coefficient of variation |
| source_summary | string | yes | Summary of source paragraph |

#### 4.2.2_within_laboratory_precision (multiple)
Extract from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| target_biomarker | string | yes | Biomarker tested |
| sample_id | string | no | Sample identifier |
| sample_level | string | yes | Sample level |
| n_days | integer | no | Number of days |
| n_runs | integer | no | Number of runs |
| n_operators | integer | no | Number of operators |
| n_total_tests | integer | yes | Total tests |
| agreement_rate_percent | number | no | Agreement rate |
| sd | number | no | Standard deviation |
| cv_percent | number | no | CV% |
| source_summary | string | yes | Summary of source paragraph |

#### 4.2.3_reproducibility (multiple)
Extract inter-laboratory precision from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| target_biomarker | string | yes | Biomarker tested |
| sample_id | string | no | Sample identifier |
| sample_level | string | yes | Sample level |
| n_sites | integer | yes | Number of sites |
| n_operators_per_site | integer | no | Operators per site |
| n_days | integer | no | Days tested |
| n_replicates_per_day | integer | no | Replicates per day |
| n_total_tests | integer | yes | Total tests |
| agreement_rate_percent | number | no | Agreement rate |
| between_site_variance | number | no | Variance between sites |
| within_site_variance | number | no | Variance within sites |
| source_summary | string | yes | Summary of source paragraph |

#### 4.3.1_limit_of_blank (multiple)
Extract from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| target_biomarker | string | yes | Biomarker |
| specimen_type | string | no | Specimen type |
| lob_value | number | yes | LoB value |
| lob_unit | string | yes | Unit |
| n_samples | integer | no | Samples tested |
| n_replicates | integer | no | Replicates |
| calculation_method | string | no | How LoB was calculated |
| source_summary | string | yes | Summary of source paragraph |

#### 4.3.2_limit_of_detection (multiple)
Extract from SSED Section IX.A. One row per biomarker/specimen.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| target_biomarker | string | yes | Biomarker tested |
| lod_value | number | yes | LoD value |
| lod_unit | string | yes | e.g., "% VAF", "copies/mL" |
| specimen_type | string | no | Specimen type |
| detection_rate_at_lod | number | no | % detected at LoD |
| n_samples_tested | integer | no | Samples tested |
| lod_determination_method | string | no | How LoD was calculated |
| source_summary | string | yes | Summary of source paragraph |

#### 4.4_cross_reactivity (multiple)
Extract from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| target_biomarker | string | yes | Target biomarker |
| potential_cross_reactant | string | yes | Substance/variant tested |
| tested_concentration | string | no | Concentration tested |
| cross_reactivity_observed | boolean | yes | true/false |
| impact_description | string | no | Impact if any |
| source_summary | string | yes | Summary of source paragraph |

#### 4.5_interference_testing (multiple)
Extract from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| target_biomarker | string | yes | Biomarker tested |
| interferent | string | yes | Interfering substance |
| interferent_type | string | no | "endogenous" or "exogenous" |
| concentration_tested | string | no | Concentration |
| interference_observed | boolean | yes | true/false |
| impact_description | string | no | Impact if any |
| source_summary | string | yes | Summary of source paragraph |

#### 4.6_carryover_contamination (multiple)
Extract from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| study_type | string | yes | "carryover" or "contamination" |
| test_description | string | yes | Description of test |
| specimen_sequence | string | no | Sample order tested |
| result | string | yes | "passed" or "failed" |
| carryover_rate_percent | number | no | % carryover if measured |
| acceptance_criteria | string | no | Criteria used |
| source_summary | string | yes | Summary of source paragraph |

#### 4.7_input_range (multiple)
Extract from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| analyte | string | yes | e.g., "DNA", "cfDNA", "RNA" |
| specimen_type | string | no | Specimen type |
| lower_limit | number | yes | Lower limit |
| upper_limit | number | yes | Upper limit |
| unit | string | yes | e.g., "ng", "ng/uL" |
| optimal_input | number | no | Optimal input |
| performance_at_lower_limit | string | no | Performance notes |
| performance_at_upper_limit | string | no | Performance notes |
| source_summary | string | yes | Summary of source paragraph |

#### 4.8_robustness_guardbanding (multiple)
Extract from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| parameter_tested | string | yes | Parameter varied |
| nominal_value | string | yes | Normal/SOP value |
| tested_range_low | string | yes | Lower bound tested |
| tested_range_high | string | yes | Upper bound tested |
| acceptance_criteria | string | no | Criteria used |
| result | string | yes | "passed", "failed", or "marginal" |
| impact_on_performance | string | no | Impact notes |
| source_summary | string | yes | Summary of source paragraph |

---

### 5. Clinical Performance

#### 5.1_clinical_study_design (single)
Extract from SSED Section X.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| study_name | string | yes | Trial name/identifier |
| study_type | string | yes | "prospective", "retrospective", or "bridging" |
| study_design | string | no | e.g., "single-arm", "randomized" |
| primary_endpoint | string | yes | Primary efficacy endpoint |
| secondary_endpoints | string | no | Comma-separated |
| sample_size_enrolled | integer | yes | Enrolled patients |
| sample_size_evaluable | integer | no | Evaluable patients |
| clinical_sites | integer | no | Number of sites |
| countries | string | no | Countries involved |
| enrollment_period | string | no | Date range |
| source_summary | string | yes | Summary of source paragraph |

#### 5.2_clinical_sensitivity_specificity (multiple)
Extract from SSED Section X. One row per analysis.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| analysis_population | string | yes | e.g., "ITT", "CDx evaluable" |
| clinical_sensitivity | number | yes | Sensitivity (0-100) |
| sensitivity_ci_lower | number | yes | 95% CI lower |
| sensitivity_ci_upper | number | yes | 95% CI upper |
| clinical_specificity | number | no | Specificity (0-100) |
| specificity_ci_lower | number | no | 95% CI lower |
| specificity_ci_upper | number | no | 95% CI upper |
| reference_method | string | no | Reference standard |
| source_summary | string | yes | Summary of source paragraph |

#### 5.3_clinical_outcomes (multiple)
Extract efficacy results from SSED Section X.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| outcome_measure | string | yes | e.g., "ORR", "PFS", "OS" |
| population | string | yes | Patient population |
| treatment_arm | string | no | Treatment group |
| n_patients | integer | yes | Number of patients |
| result_value | number | yes | Outcome value |
| result_unit | string | yes | e.g., "%", "months" |
| ci_lower | number | no | 95% CI lower |
| ci_upper | number | no | 95% CI upper |
| p_value | number | no | P-value |
| comparator_result | number | no | Comparator arm result |
| hazard_ratio | number | no | HR if applicable |
| hr_ci_lower | number | no | HR CI lower |
| hr_ci_upper | number | no | HR CI upper |
| source_summary | string | yes | Summary of source paragraph |

#### 5.4_bridging_studies (multiple)
Extract from SSED Section X if applicable.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| bridging_study_name | string | yes | Study name |
| original_assay | string | yes | Original CDx used |
| bridging_specimen_type | string | no | Specimen type |
| n_samples_bridged | integer | yes | Samples bridged |
| concordance_rate | number | yes | Concordance (0-100) |
| concordance_ci_lower | number | no | CI lower |
| concordance_ci_upper | number | no | CI upper |
| discordant_analysis | string | no | Discordant analysis |
| source_summary | string | yes | Summary of source paragraph |

#### 5.5_demographics (multiple)
Extract from SSED Section X.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| study_name | string | no | Study name |
| population_type | string | no | e.g., "CDx evaluable", "ITT" |
| total_n | integer | yes | Total patients |
| age_median | number | no | Median age |
| age_range_min | number | no | Minimum age |
| age_range_max | number | no | Maximum age |
| male_percent | number | no | % male |
| female_percent | number | no | % female |
| white_percent | number | no | % white |
| black_percent | number | no | % Black/African American |
| asian_percent | number | no | % Asian |
| hispanic_percent | number | no | % Hispanic/Latino |
| other_race_percent | number | no | % other race |
| ecog_0_percent | number | no | % ECOG 0 |
| ecog_1_percent | number | no | % ECOG 1 |
| ecog_2_plus_percent | number | no | % ECOG 2+ |
| source_summary | string | yes | Summary of source paragraph |

#### 5.6_sample_accountability (multiple)
Extract patient flow from SSED Section X.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| study_name | string | no | Study name |
| population_stage | string | yes | e.g., "enrolled", "screened", "evaluable" |
| n_count | integer | yes | Number at this stage |
| percent_of_enrolled | number | no | % of enrolled |
| exclusion_reason | string | no | Reason for exclusion |
| n_excluded_for_reason | integer | no | Number excluded |
| source_summary | string | yes | Summary of source paragraph |

#### 5.7_subgroup_analyses (multiple)
Extract from SSED Section X.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| study_name | string | no | Study name |
| subgroup_variable | string | yes | e.g., "age", "gender", "race" |
| subgroup_value | string | yes | e.g., ">=65", "Male" |
| n_subgroup | integer | yes | Number in subgroup |
| endpoint | string | yes | Endpoint analyzed |
| result_value | number | no | Result value |
| result_ci_lower | number | no | CI lower |
| result_ci_upper | number | no | CI upper |
| comparison_to_overall | string | no | Comparison notes |
| source_summary | string | yes | Summary of source paragraph |

---

### 6. Device Description Details

#### 6.1_reagent_components (multiple)
Extract from SSED Section V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| component_name | string | yes | Reagent name |
| component_type | string | no | e.g., "primer", "probe", "enzyme" |
| catalog_number | string | no | Catalog/part number |
| storage_condition | string | no | Storage requirements |
| shelf_life | string | no | Shelf life |
| source_summary | string | yes | Summary of source paragraph |

#### 6.2_instrumentation (multiple)
Extract from SSED Section V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| instrument_name | string | yes | Instrument name |
| manufacturer | string | no | Manufacturer |
| model_number | string | no | Model number |
| function | string | yes | Function in workflow |
| regulatory_status | string | no | e.g., "FDA-cleared" |
| source_summary | string | yes | Summary of source paragraph |

#### 6.3_controls (multiple)
Extract from SSED Section V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| control_name | string | yes | Control name |
| control_type | string | yes | "positive", "negative", "no-template", "internal" |
| purpose | string | yes | Purpose of control |
| acceptance_criteria | string | no | Pass/fail criteria |
| source_summary | string | yes | Summary of source paragraph |

#### 6.4_assay_workflow (multiple)
Extract from SSED Section V. One row per workflow step.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| step_number | integer | yes | Step order |
| step_name | string | yes | Step name |
| step_description | string | no | Description |
| duration | string | no | Time required |
| temperature | string | no | Temperature |
| equipment_used | string | no | Equipment |
| critical_parameters | string | no | Critical parameters |
| source_summary | string | yes | Summary of source paragraph |

#### 6.5_turnaround_time (single)
Extract from SSED Section V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| total_tat | string | yes | Total turnaround time |
| total_tat_hours | number | no | TAT in hours |
| specimen_processing_time | string | no | Processing time |
| analysis_time | string | no | Analysis time |
| reporting_time | string | no | Reporting time |
| hands_on_time | string | no | Hands-on time |
| source_summary | string | yes | Summary of source paragraph |

#### 6.6_report_content (multiple)
Extract from SSED Section V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| report_element | string | yes | Report element |
| element_description | string | no | Description |
| required_or_optional | string | no | "required" or "optional" |
| source_summary | string | yes | Summary of source paragraph |

---

### 7. Software and Algorithms

#### 7.1_software_description (single)
Extract from SSED Section V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| software_name | string | yes | Software name |
| software_version | string | yes | Version number |
| manufacturer | string | no | Manufacturer |
| function | string | yes | Primary function |
| regulatory_status | string | no | e.g., "FDA-cleared as part of device" |
| algorithm_type | string | no | "rule-based", "ML", "AI" |
| locked_or_adaptive | string | no | "locked" or "adaptive" |
| source_summary | string | yes | Summary of source paragraph |

#### 7.2_bioinformatics_pipeline (multiple)
Extract from SSED Section V.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| pipeline_step | string | yes | Step name |
| tool_name | string | no | Tool/software used |
| tool_version | string | no | Version |
| parameters | string | no | Key parameters |
| quality_thresholds | string | no | QC thresholds |
| source_summary | string | yes | Summary of source paragraph |

---

### 8. Stability

#### 8.1_reagent_stability (multiple)
Extract from SSED Section IX.A.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| component_name | string | yes | Reagent/component |
| stability_type | string | yes | "shelf-life", "in-use", "open-vial", "freeze-thaw" |
| storage_temperature | string | yes | Storage temp |
| claimed_stability | string | yes | Stability claim |
| study_duration | string | no | Study duration |
| acceptance_criteria | string | no | Criteria used |
| result | string | yes | "passed" or "failed" |
| source_summary | string | yes | Summary of source paragraph |

---

### 9. Risk Assessment

#### 9.1_identified_hazards (multiple)
Extract from SSED Section VIII.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| hazard | string | yes | Hazard description |
| hazard_category | string | no | Category |
| potential_harm | string | yes | Potential harm |
| likelihood | string | no | "rare", "uncommon", "common" |
| severity | string | no | "minor", "moderate", "serious", "life-threatening" |
| mitigation_measure | string | no | Mitigation |
| residual_risk | string | no | Residual risk level |
| source_summary | string | yes | Summary of source paragraph |

#### 9.2_benefit_risk_assessment (single)
Extract from SSED Section XII.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| benefit_summary | string | yes | Summary of benefits |
| risk_summary | string | yes | Summary of risks |
| benefit_risk_conclusion | string | yes | Overall conclusion |
| source_summary | string | yes | Summary of source paragraph |

---

### 10. Labeling

#### 10.1_warnings_and_precautions (single) - FULL TEXT
Extract VERBATIM from SSED Section III/IV/VIII.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| warnings_text | string | yes | **VERBATIM** all warnings |
| precautions_text | string | yes | **VERBATIM** all precautions |

#### 10.2_contraindications (single) - FULL TEXT
Extract VERBATIM from SSED Section III/IV.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| contraindications_text | string | yes | **VERBATIM** contraindications (or "None" if none stated) |

---

### 11. Post-Market Requirements

#### 11.1_conditions_of_approval (multiple)
Extract from SSED Section XIII.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| condition_number | integer | yes | Condition number |
| condition_description | string | yes | Description |
| condition_category | string | no | e.g., "analytical", "clinical", "labeling" |
| due_date | string | no | Due date if specified |
| status | string | no | "pending", "completed", "ongoing" |
| source_summary | string | yes | Summary of source paragraph |

#### 11.2_post_approval_studies (multiple)
Extract from SSED Section XIII if applicable.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| study_name | string | yes | Study name |
| study_objective | string | yes | Objective |
| study_type | string | no | Study type |
| target_enrollment | integer | no | Target N |
| timeline | string | no | Timeline |
| status | string | no | Status |
| source_summary | string | yes | Summary of source paragraph |

---

### 12. Additional Sections

#### 12.1_alternative_devices (multiple)
Extract from SSED Section VI.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| device_name | string | yes | Device name |
| manufacturer | string | no | Manufacturer |
| regulatory_status | string | no | e.g., "FDA-cleared", "LDT" |
| technology_type | string | no | Technology |
| indication | string | no | Indication |
| comparison_notes | string | no | Comparison notes |
| source_summary | string | yes | Summary of source paragraph |

#### 12.2_marketing_history (multiple)
Extract from SSED Section VII.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| country_region | string | yes | Country/region |
| regulatory_status | string | yes | e.g., "approved", "CE marked" |
| approval_date | date | no | Approval date |
| regulatory_body | string | no | Regulatory body |
| submission_number | string | no | Submission number |
| units_distributed | integer | no | Units distributed |
| adverse_events_reported | integer | no | AEs reported |
| source_summary | string | yes | Summary of source paragraph |

#### 12.3_potential_adverse_effects (multiple)
Extract from SSED Section VIII.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| adverse_effect | string | yes | Effect description |
| adverse_effect_category | string | no | Category |
| potential_harm | string | yes | Potential harm |
| likelihood | string | no | "rare", "uncommon", "common" |
| severity | string | no | "minor", "moderate", "serious", "life-threatening" |
| mitigation | string | no | Mitigation |
| source_summary | string | yes | Summary of source paragraph |

#### 12.4_panel_recommendation (single)
Extract from SSED Section XI.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| panel_name | string | yes | Panel name |
| panel_meeting_date | date | no | Meeting date |
| panel_referred | boolean | yes | true/false |
| referral_rationale | string | no | Rationale |
| recommendation | string | no | "approval", "approval_with_conditions", "not_approvable", "not_applicable" |
| vote_for | integer | no | Votes for |
| vote_against | integer | no | Votes against |
| vote_abstain | integer | no | Abstentions |
| key_panel_concerns | string | no | Key concerns |
| source_summary | string | yes | Summary of source paragraph |

#### 12.5_fda_conclusions (multiple)
Extract from SSED Section XII.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| conclusion_category | string | yes | "analytical_performance", "clinical_performance", "benefit_risk", "labeling", "overall" |
| conclusion_text | string | yes | Conclusion text |
| source_summary | string | yes | Summary of source paragraph |

#### 12.6_references (multiple)
Extract from SSED Section XV.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| reference_number | integer | no | Reference number |
| citation | string | yes | Full citation |
| reference_type | string | no | "journal_article", "guidance_document", "standard", "package_insert", "other" |
| relevance | string | no | What it supports |

#### 12.7_financial_disclosure (single)
Extract from SSED Section XIII.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| n_clinical_investigators | integer | no | Number of investigators |
| n_with_disclosable_interests | integer | no | Number with interests |
| disclosure_types | string | no | Types of disclosures |
| fda_analysis_performed | boolean | no | true/false |
| impact_on_study_reliability | string | no | FDA's assessment |
| source_summary | string | yes | Summary of source paragraph |

---

### NGS Extension Sheets

#### ext_ngs_sequencing_parameters (single)
For NGS-based devices only.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| sequencing_platform | string | yes | e.g., "Illumina", "Ion Torrent" |
| sequencing_chemistry | string | no | Chemistry used |
| read_length | string | no | Read length |
| coverage_depth_minimum | integer | no | Minimum coverage |
| coverage_depth_target | integer | no | Target coverage |
| reference_genome | string | no | e.g., "hg19", "GRCh38" |
| variant_caller | string | no | Variant caller used |
| annotation_databases | string | no | Databases used |
| source_summary | string | yes | Summary of source paragraph |

#### ext_cdx_therapeutic_linkage (multiple)
Detailed CDx-therapeutic linkage.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| biomarker | string | yes | Biomarker |
| therapeutic | string | yes | Drug name |
| therapeutic_indication | string | yes | Drug indication |
| cdx_claim_type | string | yes | "required", "recommended", "informational" |
| approval_pathway | string | no | "regular", "accelerated", "breakthrough" |
| clinical_trial_support | string | no | Supporting trial |
| source_summary | string | yes | Summary of source paragraph |

#### ext_cdx_clinical_trial (multiple)
Clinical trial details for CDx linkage.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| trial_name | string | yes | Trial name |
| nct_number | string | no | NCT number |
| trial_phase | string | no | Phase |
| sponsor | string | no | Sponsor |
| therapeutic_tested | string | yes | Drug tested |
| biomarker_tested | string | yes | Biomarker tested |
| patient_selection_method | string | no | Selection method |
| efficacy_results_summary | string | no | Results summary |
| source_summary | string | yes | Summary of source paragraph |

---

### 99. Uncategorized (LAST RESORT)

#### 99_uncategorized (multiple)

**IMPORTANT:** This sheet is a LAST RESORT for content that truly does not fit any other category. Before adding an entry here:

1. Review ALL sheet definitions above
2. Consider if the content could partially fit an existing sheet
3. Only use this sheet when content is genuinely novel or outside the schema scope

Excessive entries in this sheet indicate incomplete categorization and should be avoided.

| Column | Type | Required | Description |
|--------|------|----------|-------------|
| content_summary | string | yes | Brief summary of the uncategorized content |
| ssed_section | string | yes | SSED section number (e.g., "IX.A", "X.B") |
| page_number | integer | no | Page number in source document |
| content_type | string | no | e.g., "table", "figure", "text", "list" |
| potential_category | string | no | Suggested category for future schema updates |
| verbatim_excerpt | string | no | Key verbatim text if short enough |
| relevance | string | no | "high", "medium", or "low" |
| extraction_notes | string | no | Why this was uncategorized |

---

## Extraction Guidelines

1. **Read the entire SSED** before extracting to understand context
2. **Use exact values** from tables and figures - do not estimate
3. **Include confidence intervals** when provided (95% CI is standard)
4. **Preserve date format** as YYYY-MM-DD
5. **For empty sheets**, include the sheet key with an empty array `[]` or empty object `{}`
6. **For source_summary**, write 1-2 sentences summarizing the source paragraph - this enables traceability
7. **For full-text sheets**, copy text VERBATIM including formatting
8. **Minimize uncategorized entries** - always try to fit content into existing sheets first
9. **List all extracted sheets** in `_metadata.sheets_extracted`

## Quality Checks

Before returning the extraction:
- [ ] All required fields are populated
- [ ] Numeric values are numbers, not strings
- [ ] Dates are in YYYY-MM-DD format
- [ ] Boolean values are true/false, not strings
- [ ] Arrays are used for "multiple" cardinality sheets
- [ ] Objects are used for "single" cardinality sheets
- [ ] source_summary is included for all non-full-text sheets
- [ ] Uncategorized sheet has minimal entries (ideally zero)
- [ ] Each uncategorized entry explains why it couldn't be categorized
