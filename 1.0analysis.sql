============================================================
FILE: analysis/1.0_analysis.sql
Description: Exploratory data analysis queries for the sleep rhythm clinical study dataset.
============================================================

USE sleep_study;

-- 1. OVERVIEW ──────────────────────────────────────────────────────────────

-- Total participants in the study
SELECT COUNT(*) AS total_participants
FROM demographic;

-- Total longitudinal sleep records
SELECT COUNT(*) AS total_sleep_records
FROM sleep_rhythm;

-- Participants with at least one sleep record
SELECT COUNT(DISTINCT ID) AS participants_with_records
FROM sleep_rhythm;


-- 2. DEMOGRAPHIC PROFILE ───────────────────────────────────────────────────

-- Age distribution (min, avg, max)
SELECT
    ROUND(MIN(age), 1)  AS age_min,
    ROUND(AVG(age), 1)  AS age_avg,
    ROUND(MAX(age), 1)  AS age_max
FROM demographic;

-- BMI category breakdown
SELECT
    BMI_category,
    CASE BMI_category
        WHEN 1 THEN 'Normal'
        WHEN 2 THEN 'Overweight'
        WHEN 3 THEN 'Obese'
        WHEN 4 THEN 'Underweight'
        ELSE 'Unknown'
    END AS label,
    COUNT(*)                                    AS n,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM demographic
GROUP BY BMI_category
ORDER BY BMI_category;

-- Participants with eye conditions
SELECT
    eye_conditions,
    CASE eye_conditions WHEN 0 THEN 'No' ELSE 'Yes' END AS has_eye_condition,
    COUNT(*) AS n
FROM demographic
GROUP BY eye_conditions;


-- 3. SLEEP RHYTHM PATTERNS ─────────────────────────────────────────────────

-- Sex distribution among sleep records
SELECT
    sex,
    CASE sex WHEN 0 THEN 'Male' WHEN 1 THEN 'Female' ELSE 'Unknown' END AS gender,
    COUNT(DISTINCT ID) AS participants,
    COUNT(*)           AS records
FROM sleep_rhythm
GROUP BY sex;

-- Records per trimester
SELECT
    trimester,
    COUNT(*)           AS records,
    COUNT(DISTINCT ID) AS participants
FROM sleep_rhythm
GROUP BY trimester
ORDER BY trimester;

-- DST (Daylight Saving Time) effect: how many records fall in DST period
SELECT
    DST,
    CASE DST WHEN 0 THEN 'Standard Time' WHEN 1 THEN 'DST Active' END AS period,
    COUNT(*) AS records
FROM sleep_rhythm
GROUP BY DST;

-- Distance learning participants per trimester
SELECT
    trimester,
    SUM(distance_learning)                          AS distance_learning_records,
    COUNT(*)                                        AS total_records,
    ROUND(SUM(distance_learning) * 100.0 / COUNT(*), 1) AS pct_distance_learning
FROM sleep_rhythm
GROUP BY trimester
ORDER BY trimester;


-- 4. JOINED ANALYSIS ───────────────────────────────────────────────────────

-- Average BMI by sex
SELECT
    sr.sex,
    CASE sr.sex WHEN 0 THEN 'Male' WHEN 1 THEN 'Female' END AS gender,
    ROUND(AVG(d.BMI), 1)    AS avg_BMI,
    ROUND(AVG(d.age), 1)    AS avg_age,
    COUNT(DISTINCT sr.ID)   AS participants
FROM sleep_rhythm sr
JOIN demographic d ON sr.ID = d.ID
GROUP BY sr.sex;

-- Disease prevalence by BMI category
SELECT
    d.BMI_category,
    CASE d.BMI_category
        WHEN 1 THEN 'Normal'
        WHEN 2 THEN 'Overweight'
        WHEN 3 THEN 'Obese'
        WHEN 4 THEN 'Underweight'
    END AS bmi_label,
    ROUND(AVG(sr.has_diseases) * 100, 1) AS pct_with_diseases,
    COUNT(DISTINCT sr.ID)                AS participants
FROM sleep_rhythm sr
JOIN demographic d ON sr.ID = d.ID
GROUP BY d.BMI_category
ORDER BY d.BMI_category;

-- Birth year distribution (decade cohorts)
SELECT
    CONCAT(FLOOR(birth_year / 10) * 10, 's') AS decade,
    COUNT(DISTINCT ID)                        AS participants
FROM sleep_rhythm
WHERE birth_year IS NOT NULL
GROUP BY decade
ORDER BY decade;


-- 5. DATA QUALITY CHECKS ───────────────────────────────────────────────────

-- Participants in sleep_rhythm not present in demographic
SELECT COUNT(DISTINCT sr.ID) AS orphan_sleep_records
FROM sleep_rhythm sr
LEFT JOIN demographic d ON sr.ID = d.ID
WHERE d.ID IS NULL;

-- NULL counts per column in demographic
SELECT
    SUM(CASE WHEN age          IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN height_cm    IS NULL THEN 1 ELSE 0 END) AS null_height,
    SUM(CASE WHEN weight_kg    IS NULL THEN 1 ELSE 0 END) AS null_weight,
    SUM(CASE WHEN BMI          IS NULL THEN 1 ELSE 0 END) AS null_BMI,
    SUM(CASE WHEN BMI_category IS NULL THEN 1 ELSE 0 END) AS null_BMI_category
FROM demographic;

-- NULL counts per column in sleep_rhythm
SELECT
    SUM(CASE WHEN sex              IS NULL THEN 1 ELSE 0 END) AS null_sex,
    SUM(CASE WHEN has_diseases     IS NULL THEN 1 ELSE 0 END) AS null_diseases,
    SUM(CASE WHEN birth_year       IS NULL THEN 1 ELSE 0 END) AS null_birth_year,
    SUM(CASE WHEN trimester        IS NULL THEN 1 ELSE 0 END) AS null_trimester
FROM sleep_rhythm;
