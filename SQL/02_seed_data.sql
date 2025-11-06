-- Author: Soundarya S
-- Project: StreamWise - Netflix Decision Fatigue Analytics
-- Purpose: Insert seed data for TimeOfDay, DimDate, DimUserProfile, DimContent and sample Fact Sessions
-- Date: 2025-11-06

USE StreamWiseDB;
GO

-------------------------------------------------------------
-- 1) Seed Time Buckets
-------------------------------------------------------------
INSERT INTO sw.DimTimeOfDay (BucketName)
VALUES ('Morning'),('Afternoon'),('Evening'),('Late Night');


-------------------------------------------------------------
-- 2) Seed Last 365 Days Calendar
-------------------------------------------------------------
;WITH d AS (
    SELECT TOP (365)
        CAST(DATEADD(DAY, -ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) +1, CAST(GETUTCDATE() AS date)) AS DATE) AS FullDate
    FROM sys.all_objects
)
INSERT INTO sw.DimDate(DateID, FullDate, [Year], [Month], [Day], WeekOfYear)
SELECT 
    (YEAR(FullDate)*10000) + (MONTH(FullDate)*100) + DAY(FullDate) AS DateID,
    FullDate,
    YEAR(FullDate),
    MONTH(FullDate),
    DAY(FullDate),
    DATEPART(WEEK,FullDate)
FROM d;


-------------------------------------------------------------
-- 3) Seed Sample Users (Psychology Personas)
-------------------------------------------------------------
INSERT INTO sw.DimUserProfile (AgeGroup, PersonaType)
VALUES
('Young Adult','Curious Explorer'),
('Adult','Comfort Rewatcher'),
('Adult','Weekend Binger'),
('Young Adult','Social Recommender');


-------------------------------------------------------------
-- 4) Seed Sample Content Titles (Cross Genre)
-------------------------------------------------------------
INSERT INTO sw.DimContent (Title,Genre,ContentType,AvgDurationMin,MaturityRating)
VALUES
('Stranger Things','Sci-Fi','Series',50,'TV-14'),
('Money Heist','Crime','Series',45,'TV-MA'),
('The Conjuring','Horror','Movie',105,'R'),
('The Hangover','Comedy','Movie',100,'R'),
('The Crown','Drama','Series',52,'TV-14'),
('Inception','Sci-Fi','Movie',148,'PG-13');


-------------------------------------------------------------
-- 5) Insert 100 Synthetic View Sessions (Realistic Patterns)
-------------------------------------------------------------
;WITH n AS (
    SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM sys.all_objects
),
randvals AS (
    SELECT 
        rn,
        ((ABS(CHECKSUM(NEWID())) % 4)+1) AS UserID,
        ((ABS(CHECKSUM(NEWID())) % 6)+1) AS ContentID,
        (SELECT TOP 1 DateID FROM sw.DimDate ORDER BY NEWID()) AS DateID,
        (SELECT TOP 1 TimeBucketID FROM sw.DimTimeOfDay ORDER BY NEWID()) AS TimeBucketID,
        CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 40 THEN 'Continue Watching'
             WHEN ABS(CHECKSUM(NEWID())) % 100 < 70 THEN 'Top Picks'
             WHEN ABS(CHECKSUM(NEWID())) % 100 < 90 THEN 'Trending Now'
             ELSE 'Because You Watched'
        END AS RecommendationType,
        (ABS(CHECKSUM(NEWID())) % 200) AS ScrollDurationSec,
        (ABS(CHECKSUM(NEWID())) % 130) AS WatchDurationMin
    FROM n
)
INSERT INTO sw.FactViewSession
(UserID,ContentID,DateID,TimeBucketID,ScrollDurationSec,WatchDurationMin,RecommendationType,DidUserWatch,SatisfactionScore)
SELECT
    rv.UserID,
    rv.ContentID,
    rv.DateID,
    rv.TimeBucketID,
    rv.ScrollDurationSec,
    rv.WatchDurationMin,
    rv.RecommendationType,
    CASE WHEN rv.WatchDurationMin > 10 THEN 1 ELSE 0 END AS DidUserWatch,
    CASE WHEN rv.WatchDurationMin > 60 THEN 5
         WHEN rv.WatchDurationMin > 40 THEN 4
         WHEN rv.WatchDurationMin > 20 THEN 3
         WHEN rv.WatchDurationMin > 0  THEN 2
         ELSE NULL END AS SatisfactionScore
FROM randvals rv;
