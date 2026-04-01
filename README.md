# Sleep Rhythm Clinical Study — MySQL Dataset

A structured MySQL dataset derived from a clinical study on sleep rhythms.  
This repository contains anonymised participant data, the database schema, and exploratory SQL analysis queries.

---

## Database Schema

Two tables with a one-to-many relationship:

```
demographic (1) ──────< sleep_rhythm (N)
     ID                      ID  (FK)
```

### `demographic`
| Column | Type | Description |
|--------|------|-------------|
| `ID` | INT (PK) | Participant identifier |
| `age` | DECIMAL(4,1) | Age at enrollment (years) |
| `height_cm` | INT | Height in cm |
| `weight_kg` | DECIMAL(5,1) | Weight in kg |
| `BMI` | DECIMAL(4,1) | Body Mass Index |
| `BMI_category` | TINYINT | 1=Normal · 2=Overweight · 3=Obese · 4=Underweight |
| `BMI_simplified` | TINYINT | Simplified BMI grouping |
| `eye_conditions` | TINYINT | 0=No · 1=Has eye conditions |

### `sleep_rhythm`
| Column | Type | Description |
|--------|------|-------------|
| `record_id` | INT (PK, AUTO) | Record identifier |
| `ID` | INT (FK) | Participant identifier |
| `sex` | TINYINT | 0=Male · 1=Female |
| `has_diseases` | TINYINT | 0=No or negligible · 1=Yes |
| `distance_learning` | TINYINT | 0=No · 1=Yes |
| `DST` | TINYINT | Daylight Saving Time active: 0=No · 1=Yes |
| `trimester` | TINYINT | Study registration trimester (1–4) |
| `birth_year` | SMALLINT | Year of birth (anonymized) |

---

## Analysis Overview

`04_analysis.sql` covers:

- **Overview** participant count, record count, coverage
- **Demographic profile** age distribution, BMI categories, eye conditions
- **Sleep rhythm patterns** sex distribution, records per trimester, DST effect, distance learning
- **Joined analysis** avg BMI by sex, disease prevalence by BMI category, birth year cohorts
- **Data quality checks** orphan records, NULL counts per column

---

## Privacy & Anonymization

All data has been anonymised before publication. The following transformations were applied:

| Original field | Action | Reason |
|----------------|--------|--------|
| `t000_city`, `t000_province/country`, `t000_cap` | **Removed** | Geographic re-identification risk |
| `t000_diseases` (free text) | **Removed** | Sensitive health data (GDPR Art. 9) — binary flag retained |
| `t000_medication` (free text) | **Removed** | Sensitive health data (GDPR Art. 9) |
| `Data di nascita` (full date) | **Replaced** with `birth_year` | PII — full DOB reduced to year only |
| `età calcolata`, `BMI` | **Rounded** to 1 decimal | Reduce precision for re-identification |

⚠️ The original raw files are **not** included in this repository.

---

## Dataset Summary

| Dataset | Rows | Columns |
|---------|------|---------|
| `demographic_anon.csv` | 877 | 8 |
| `sleeprhythm_anon.csv` | 7,766 | 7 |

---

## License

This dataset is shared for academic and research purposes only.  
Please cite appropriately if used in publications.
