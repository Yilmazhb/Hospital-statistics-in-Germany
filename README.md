# Hospital statistics in Germany

### Technologies Used:

Tool: Microsoft SQL

Skills: Joins, CTEs, aggregate functions, Case

### Dataset:  
The dataset is sourced from Germany's official data portal "GovData – Das Datenportal für Deutschland", providing authoritative hospital statistics with ICD-10 classifications, patient demographics, and nationwide coverage. This represents official public health data from the German healthcare system.
  
  - ### Problem:
    Specifically, the problem lies in the fact that valuable insights about disease patterns, age distributions, and gender-specific differences remain hidden within the available hospital data. Health policymakers, hospital managers, and public health experts lack clear visibility into questions such as: Which diseases burden the system the most? Are there age-specific risk groups that require special attention? How do disease patterns differ between men and women?
  
  - ### How I Plan On Solving the Problem:
    I address this problem through a comprehensive SQL-based analysis of German hospital statistics. My approach involves systematically examining the raw hospital data and transforming it into actionable insights. Using advanced SQL techniques, I break down the data across various dimensions: by diagnosis categories, age groups and gender. My goal is to create a data-driven foundation that enables healthcare institutions to make more accurate forecasts,                                                  develop targeted prevention measures, and allocate their limited resources more efficiently. The analysis not only reveals current states but also provides the methodological basis for future trend analyses and comparative studies.

# Questions I Wanted To Answer From the Dataset:

# 1. What are the top 10 most frequently occurring diagnoses overall?
```sql
SELECT TOP 10 
    ICD10_Code,
    Diagnose_Bezeichnung,
    SUM(insgesamt_insgesamt) as Gesamtfälle
FROM Krankenhausstatistik
GROUP BY ICD10_Code, Diagnose_Bezeichnung
ORDER BY Gesamtfälle DESC;
```
### Result:

<img width="469" height="210" alt="Screenshot 2025-11-27 134857" src="https://github.com/user-attachments/assets/79a08c47-b089-492d-a95f-f07253e1f18d" />

In summary, chronic lifestyle-related diseases (circulatory, digestive, muscular) together with acute events (injuries) and serious diagnoses such as cancer significantly shape everyday clinical practice in hospitals. The data provides an important basis for planning preventive measures and resource management in the healthcare system.

# 2. How many male and female patients are there?
```sql
SELECT 
    COUNT(DISTINCT ICD10_Code) as Anzahl_Diagnosen,
    SUM(insgesamt_insgesamt) as Gesamtpatienten,
    SUM(maennlich_insgesamt) as Männliche_Patienten,
    SUM(weiblich_insgesamt) as Weibliche_Patienten,
    CAST(SUM(maennlich_insgesamt) * 100.0 / SUM(insgesamt_insgesamt) as DECIMAL(5,2)) as Männlich_Prozent,
    CAST(SUM(weiblich_insgesamt) * 100.0 / SUM(insgesamt_insgesamt) as DECIMAL(5,2)) as Weiblich_Prozent
FROM Krankenhausstatistik;
```
### Result:

<img width="662" height="39" alt="Screenshot 2025-11-27 135246" src="https://github.com/user-attachments/assets/0e439404-e71a-4d8d-8005-27da319fb3d4" />

The distribution between male and female patients is almost equal, with a slight surplus of male patients of approximately 3.28%. The almost equal distribution underlines that the healthcare system is used to a similar extent by both genders and highlights the need for gender-equitable care in all areas of medicine.


# 3. How are patients distributed across different age groups?
```sql
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
```
### Result:

<img width="976" height="38" alt="Screenshot 2025-11-27 141409" src="https://github.com/user-attachments/assets/2f05928c-b3a4-45bc-b002-cd4091a97754" />

The distribution shows two main burden points in the healthcare system: young adults aged 20–25 and people in early old age (65–70). This finding is crucial for capacity planning in healthcare and for tailoring care services to the needs of these population groups, which require particularly intensive treatment.

# 4. Which diagnoses show the largest difference in patient numbers between males and females?
```sql
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
```
### Result:

<img width="572" height="216" alt="Screenshot 2025-11-27 141715" src="https://github.com/user-attachments/assets/4ea0bcac-4492-4bc5-a1c4-765c5f7c13fe" />

Although more women than men were treated overall (difference: 589,559 cases), the distribution across the individual clinical pictures is very uneven. The data underscores the need for gender sensitive medicine that takes into account both biological differences and socio-cultural influences in prevention, diagnosis and therapy.

# 5. What is the average age of patients for each diagnosis group?
```sql
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
```
### Result:

<img width="1066" height="557" alt="Screenshot 2025-11-27 142627" src="https://github.com/user-attachments/assets/d73a9d49-8442-4299-a0be-b30189d72899" />

These figures highlight the enormous importance of geriatric medicine within the healthcare system. The most common diagnoses among senior citizens, including heart failure, bone fractures, dementia, and dehydration, clearly demonstrate the specific care requirements of this patient population.

# Conclusion
The analyses provide a comprehensive picture of inpatient care in Germany, revealing not just the most common diseases, but also who they affect and at what stage of life. The data shows a clear dominance of chronic, often lifestyle-related conditions. Diseases of the circulatory system are the leading cause of hospital stays, closely followed by injuries and disorders of the digestive and musculoskeletal systems. This underscores the ongoing central role of internal medicine and trauma surgery in clinical practice.

While the overall number of patients is nearly balanced between men and women, distinct gender patterns emerge for specific diagnoses. Men are significantly more susceptible to ischemic heart disease and substance abuse disorders. Women, conversely, report a higher incidence of musculoskeletal conditions and are, for biological reasons, the sole group affected by pregnancy and childbirth related diagnoses. This highlights the importance of gender sensitive approaches in medicine.

The age distribution of patients points to two key demographics: young adults aged 20 to 25 and seniors in their early retirement years, from 65 to 70. Furthermore, examining the diagnoses with the highest average age sheds light on the challenges of advanced age. Conditions like heart failure, dementia, and hip fractures define the clinical profile of geriatric patients, underscoring the expanding care requirements of an aging population.

In conclusion, the data reflects a dual challenge for the healthcare system: managing widespread chronic diseases across the general population, while simultaneously providing specialized care for the unique needs of the elderly. These insights are invaluable for strategic planning, targeted prevention, and shaping a future ready medical system that can effectively serve all segments of society.
