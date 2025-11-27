USE Krankenhauspatienten;

-- 1. How many male and female patients are there?
SELECT 
    COUNT(DISTINCT ICD10_Code) as Anzahl_Diagnosen,
    SUM(insgesamt_insgesamt) as Gesamtpatienten,
    SUM(maennlich_insgesamt) as Männliche_Patienten,
    SUM(weiblich_insgesamt) as Weibliche_Patienten,
    CAST(SUM(maennlich_insgesamt) * 100.0 / SUM(insgesamt_insgesamt) as DECIMAL(5,2)) as Männlich_Prozent,
    CAST(SUM(weiblich_insgesamt) * 100.0 / SUM(insgesamt_insgesamt) as DECIMAL(5,2)) as Weiblich_Prozent
FROM Krankenhausstatistik;




-- 2. What are the top 10 most frequently occurring diagnoses overall?
SELECT TOP 10 
    ICD10_Code,
    Diagnose_Bezeichnung,
    SUM(insgesamt_insgesamt) as Gesamtfaelle
FROM Krankenhausstatistik
GROUP BY ICD10_Code, Diagnose_Bezeichnung
ORDER BY Gesamtfaelle DESC;





-- 3. Which diagnoses are most common among patients under the age of 10?
SELECT TOP 10
    Diagnose_Bezeichnung,
    SUM(insgesamt_unter_1_Jahr + insgesamt_1_bis_unter_5_Jahre + insgesamt_5_bis_unter_10_Jahre) as Kinder_Fälle
FROM Krankenhausstatistik
GROUP BY Diagnose_Bezeichnung
ORDER BY Kinder_Fälle DESC;





-- 4. What are the most common diagnoses among seniors aged 75 and older?
SELECT TOP 10
    Diagnose_Bezeichnung,
    SUM(insgesamt_75_bis_unter_80_Jahre + insgesamt_80_bis_unter_85_Jahre + 
        insgesamt_85_bis_unter_90_Jahre + insgesamt_90_bis_unter_95_Jahre + 
        insgesamt_95_Jahre_und_mehr) as Senioren_Fälle
FROM Krankenhausstatistik
GROUP BY Diagnose_Bezeichnung
ORDER BY Senioren_Fälle DESC;




-- 5. What are the most common mental health diagnoses among young people aged 15 to 25?
SELECT TOP 10
    Diagnose_Bezeichnung,
    SUM(insgesamt_15_bis_unter_18_Jahre + insgesamt_18_bis_unter_20_Jahre + insgesamt_20_bis_unter_25_Jahre) as Jugend_Fälle
FROM Krankenhausstatistik
GROUP BY Diagnose_Bezeichnung
ORDER BY Jugend_Fälle DESC;

SELECT 
    Diagnose_Bezeichnung,
    SUM(insgesamt_insgesamt) as Gesamtfaelle,
    SUM(maennlich_insgesamt) as Maennlich,
    SUM(weiblich_insgesamt) as Weiblich
FROM Krankenhausstatistik
WHERE ICD10_Code LIKE 'F%'
GROUP BY Diagnose_Bezeichnung
ORDER BY Gesamtfaelle DESC;



-- 6. How are patients distributed across different age groups?
SELECT 
    SUM(insgesamt_unter_1_Jahr) as Unter_1_Jahr,
    SUM(insgesamt_1_bis_unter_5_Jahre) as Kinder_1_5,
    SUM(insgesamt_5_bis_unter_10_Jahre) as Kinder_5_10,
    SUM(insgesamt_10_bis_unter_15_Jahre) as Jugendliche_10_15,
    SUM(insgesamt_15_bis_unter_18_Jahre) as Jugendliche_15_18,
    SUM(insgesamt_18_bis_unter_20_Jahre) as Junge_Erwachsene_18_20,
    SUM(insgesamt_20_bis_unter_25_Jahre) as Erwachsene_20_25,
    SUM(insgesamt_65_bis_unter_70_Jahre) as Senioren_65_70,
    SUM(insgesamt_80_bis_unter_85_Jahre) as Hochbetagte_80_85,
    SUM(insgesamt_95_Jahre_und_mehr) as Über_95
FROM Krankenhausstatistik;




-- 7. What are the Top 10 most common diagnoses?
SELECT TOP 10 
    ICD10_Code,
    Diagnose_Bezeichnung,
    SUM(insgesamt_insgesamt) as Gesamtfälle
FROM Krankenhausstatistik
GROUP BY ICD10_Code, Diagnose_Bezeichnung
ORDER BY Gesamtfälle DESC;





-- 8. Which diagnoses show the largest difference in patient numbers between males and females?
SELECT TOP 10
    Diagnose_Bezeichnung,
    SUM(maennlich_insgesamt) as Männlich,
    SUM(weiblich_insgesamt) as Weiblich,
    ABS(SUM(maennlich_insgesamt) - SUM(weiblich_insgesamt)) as Differenz,
    CASE 
        WHEN SUM(maennlich_insgesamt) > SUM(weiblich_insgesamt) THEN 'Männer häufiger'
        ELSE 'Frauen häufiger'
    END as Tendenz
FROM Krankenhausstatistik
WHERE insgesamt_insgesamt > 1000  
GROUP BY Diagnose_Bezeichnung
ORDER BY Differenz DESC;





-- 9. Which age group has the highest number of cases?
SELECT 
    'Unter 1 Jahr' as Altersgruppe, SUM(insgesamt_unter_1_Jahr) as Faelle FROM Krankenhausstatistik
UNION ALL SELECT '1-5 Jahre', SUM(insgesamt_1_bis_unter_5_Jahre) FROM Krankenhausstatistik
UNION ALL SELECT '5-10 Jahre', SUM(insgesamt_5_bis_unter_10_Jahre) FROM Krankenhausstatistik
UNION ALL SELECT '10-15 Jahre', SUM(insgesamt_10_bis_unter_15_Jahre) FROM Krankenhausstatistik
UNION ALL SELECT '15-18 Jahre', SUM(insgesamt_15_bis_unter_18_Jahre) FROM Krankenhausstatistik
ORDER BY Faelle DESC;





-- 10. What is the average age of patients for each diagnosis group?
SELECT 
    ICD10_Code,
    Diagnose_Bezeichnung,
    SUM(insgesamt_insgesamt) as Gesamtfälle,
    CAST(
        (SUM(0.5 * insgesamt_unter_1_Jahr + 3.0 * insgesamt_1_bis_unter_5_Jahre + 7.5 * insgesamt_5_bis_unter_10_Jahre +
          12.5 * insgesamt_10_bis_unter_15_Jahre + 16.5 * insgesamt_15_bis_unter_18_Jahre + 19.0 * insgesamt_18_bis_unter_20_Jahre +
          22.5 * insgesamt_20_bis_unter_25_Jahre + 27.5 * insgesamt_25_bis_unter_30_Jahre + 32.5 * insgesamt_30_bis_unter_35_Jahre +
          37.5 * insgesamt_35_bis_unter_40_Jahre + 42.5 * insgesamt_40_bis_unter_45_Jahre + 47.5 * insgesamt_45_bis_unter_50_Jahre +
          52.5 * insgesamt_50_bis_unter_55_Jahre + 57.5 * insgesamt_55_bis_unter_60_Jahre + 62.5 * insgesamt_60_bis_unter_65_Jahre +
          67.5 * insgesamt_65_bis_unter_70_Jahre + 72.5 * insgesamt_70_bis_unter_75_Jahre + 77.5 * insgesamt_75_bis_unter_80_Jahre +
          82.5 * insgesamt_80_bis_unter_85_Jahre + 87.5 * insgesamt_85_bis_unter_90_Jahre + 92.5 * insgesamt_90_bis_unter_95_Jahre +
          97.5 * insgesamt_95_Jahre_und_mehr)) / 
        NULLIF(SUM(insgesamt_insgesamt), 0)
    as DECIMAL(5,2)) as Durchschnittsalter,
    
    
    CAST(SUM(insgesamt_unter_1_Jahr) * 100.0 / NULLIF(SUM(insgesamt_insgesamt), 0) as DECIMAL(5,2)) as Unter_1_Jahr_Prozent,
    CAST(SUM(insgesamt_1_bis_unter_5_Jahre) * 100.0 / NULLIF(SUM(insgesamt_insgesamt), 0) as DECIMAL(5,2)) as Kinder_1_5_Prozent,
    CAST(SUM(insgesamt_65_bis_unter_70_Jahre) * 100.0 / NULLIF(SUM(insgesamt_insgesamt), 0) as DECIMAL(5,2)) as Senioren_65_70_Prozent,
    CAST(SUM(insgesamt_80_bis_unter_85_Jahre) * 100.0 / NULLIF(SUM(insgesamt_insgesamt), 0) as DECIMAL(5,2)) as Hochbetagte_80_85_Prozent

FROM Krankenhausstatistik
WHERE insgesamt_insgesamt > 0
GROUP BY ICD10_Code, Diagnose_Bezeichnung
ORDER BY Durchschnittsalter DESC;



