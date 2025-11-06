-- Author: Soundarya S
-- Project: StreamWise - Netflix Decision Fatigue Analytics
-- Purpose: KPI Views to measure decision fatigue patterns
-- Date: 2025-11-06

USE StreamWiseDB;
GO

-------------------------------------------------------------
-- KPI 1: Fatigue by Recommendation Type
-------------------------------------------------------------
CREATE OR ALTER VIEW sw.vKPI_FatigueByRecommendationType AS
SELECT 
    RecommendationType,
    AVG(ScrollDurationSec) AS AvgScrollSec,
    AVG(WatchDurationMin)  AS AvgWatchMin,
    AVG(CAST(DidUserWatch AS DECIMAL(5,2))) * 100 AS WatchSuccessRate_Pct
FROM sw.FactViewSession
GROUP BY RecommendationType;


-------------------------------------------------------------
-- KPI 2: Fatigue by Persona Type
-------------------------------------------------------------
CREATE OR ALTER VIEW sw.vKPI_FatigueByPersona AS
SELECT 
    p.PersonaType,
    AVG(f.ScrollDurationSec) AS AvgScrollSec,
    AVG(f.WatchDurationMin)  AS AvgWatchMin,
    AVG(CAST(f.DidUserWatch AS DECIMAL(5,2))) * 100 AS WatchSuccessRate_Pct
FROM sw.FactViewSession f
JOIN sw.DimUserProfile p ON p.UserID = f.UserID
GROUP BY p.PersonaType;


-------------------------------------------------------------
-- KPI 3: Final Fatigue Score Ranking
-------------------------------------------------------------
CREATE OR ALTER VIEW sw.vKPI_DecisionFatigueScore AS
SELECT 
    RecommendationType,
    AVG(ScrollDurationSec) AS AvgScrollSec,
    AVG(CAST(DidUserWatch AS DECIMAL(5,2))) * 100 AS WatchSuccessRate_Pct,
    -- Higher score = worse decision fatigue source
    (AVG(ScrollDurationSec) / 200.0) - (AVG(CAST(DidUserWatch AS DECIMAL(5,2)))) AS FatigueScore
FROM sw.FactViewSession
GROUP BY RecommendationType;
GO
