USE Krankenhauspatienten;

CREATE TABLE Krankenhausstatistik (
    Jahr INT,
    ICD10_Code VARCHAR(20),
    Diagnose_Bezeichnung NVARCHAR(500),
    
    -- Männliche Altersgruppen
    maennlich_unter_1_Jahr INT,
    maennlich_1_bis_unter_5_Jahre INT,
    maennlich_5_bis_unter_10_Jahre INT,
    maennlich_10_bis_unter_15_Jahre INT,
    maennlich_15_bis_unter_18_Jahre INT,
    maennlich_18_bis_unter_20_Jahre INT,
    maennlich_20_bis_unter_25_Jahre INT,
    maennlich_25_bis_unter_30_Jahre INT,
    maennlich_30_bis_unter_35_Jahre INT,
    maennlich_35_bis_unter_40_Jahre INT,
    maennlich_40_bis_unter_45_Jahre INT,
    maennlich_45_bis_unter_50_Jahre INT,
    maennlich_50_bis_unter_55_Jahre INT,
    maennlich_55_bis_unter_60_Jahre INT,
    maennlich_60_bis_unter_65_Jahre INT,
    maennlich_65_bis_unter_70_Jahre INT,
    maennlich_70_bis_unter_75_Jahre INT,
    maennlich_75_bis_unter_80_Jahre INT,
    maennlich_80_bis_unter_85_Jahre INT,
    maennlich_85_bis_unter_90_Jahre INT,
    maennlich_90_bis_unter_95_Jahre INT,
    maennlich_95_Jahre_und_mehr INT,
    maennlich_insgesamt INT,
    
    -- Weibliche Altersgruppen
    weiblich_unter_1_Jahr INT,
    weiblich_1_bis_unter_5_Jahre INT,
    weiblich_5_bis_unter_10_Jahre INT,
    weiblich_10_bis_unter_15_Jahre INT,
    weiblich_15_bis_unter_18_Jahre INT,
    weiblich_18_bis_unter_20_Jahre INT,
    weiblich_20_bis_unter_25_Jahre INT,
    weiblich_25_bis_unter_30_Jahre INT,
    weiblich_30_bis_unter_35_Jahre INT,
    weiblich_35_bis_unter_40_Jahre INT,
    weiblich_40_bis_unter_45_Jahre INT,
    weiblich_45_bis_unter_50_Jahre INT,
    weiblich_50_bis_unter_55_Jahre INT,
    weiblich_55_bis_unter_60_Jahre INT,
    weiblich_60_bis_unter_65_Jahre INT,
    weiblich_65_bis_unter_70_Jahre INT,
    weiblich_70_bis_unter_75_Jahre INT,
    weiblich_75_bis_unter_80_Jahre INT,
    weiblich_80_bis_unter_85_Jahre INT,
    weiblich_85_bis_unter_90_Jahre INT,
    weiblich_90_bis_unter_95_Jahre INT,
    weiblich_95_Jahre_und_mehr INT,
    weiblich_insgesamt INT,
    
    -- Gesamt Altersgruppen
    insgesamt_unter_1_Jahr INT,
    insgesamt_1_bis_unter_5_Jahre INT,
    insgesamt_5_bis_unter_10_Jahre INT,
    insgesamt_10_bis_unter_15_Jahre INT,
    insgesamt_15_bis_unter_18_Jahre INT,
    insgesamt_18_bis_unter_20_Jahre INT,
    insgesamt_20_bis_unter_25_Jahre INT,
    insgesamt_25_bis_unter_30_Jahre INT,
    insgesamt_30_bis_unter_35_Jahre INT,
    insgesamt_35_bis_unter_40_Jahre INT,
    insgesamt_40_bis_unter_45_Jahre INT,
    insgesamt_45_bis_unter_50_Jahre INT,
    insgesamt_50_bis_unter_55_Jahre INT,
    insgesamt_55_bis_unter_60_Jahre INT,
    insgesamt_60_bis_unter_65_Jahre INT,
    insgesamt_65_bis_unter_70_Jahre INT,
    insgesamt_70_bis_unter_75_Jahre INT,
    insgesamt_75_bis_unter_80_Jahre INT,
    insgesamt_80_bis_unter_85_Jahre INT,
    insgesamt_85_bis_unter_90_Jahre INT,
    insgesamt_90_bis_unter_95_Jahre INT,
    insgesamt_95_Jahre_und_mehr INT,
    insgesamt_insgesamt INT
);


BULK INSERT Krankenhausstatistik
FROM 'C:\Krankenhausstatistik.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2, 
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001', 
    DATAFILETYPE = 'widechar' 
);