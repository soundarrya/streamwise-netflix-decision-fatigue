-- Author: Soundarya S
-- Project: StreamWise - Netflix Decision Fatigue Analytics
-- Purpose: Create schema + core dimension model + fact table
-- Date: 2025-11-06

-------------------------------------------------------------
-- Create Database Schema
-------------------------------------------------------------
USE StreamWiseDB;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='sw')
    EXEC('CREATE SCHEMA sw');
GO

-------------------------------------------------------------
-- Dimension: User Profiles (Psychological Personas)
-------------------------------------------------------------
CREATE TABLE sw.DimUserProfile (
    UserID        INT IDENTITY(1,1) PRIMARY KEY,
    AgeGroup      VARCHAR(20) NOT NULL CHECK (AgeGroup IN ('Teen','Young Adult','Adult','Senior')),
    PersonaType   VARCHAR(30) NOT NULL CHECK (PersonaType IN ('Comfort Rewatcher','Curious Explorer','Weekend Binger','Social Recommender')),
    CreatedAt     DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_DimUserProfile_Persona ON sw.DimUserProfile(PersonaType);

-------------------------------------------------------------
-- Dimension: Content Metadata
-------------------------------------------------------------
CREATE TABLE sw.DimContent (
    ContentID        INT IDENTITY(1,1) PRIMARY KEY,
    Title            VARCHAR(150) NOT NULL,
    Genre            VARCHAR(40)  NOT NULL,
    ContentType      VARCHAR(10)  NOT NULL CHECK (ContentType IN ('Movie','Series')),
    AvgDurationMin   INT NULL CHECK (AvgDurationMin IS NULL OR AvgDurationMin BETWEEN 1 AND 600),
    MaturityRating   VARCHAR(10) NULL,
    CreatedAt        DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE INDEX IX_DimContent_Genre ON sw.DimContent(Genre);
CREATE INDEX IX_DimContent_Type  ON sw.DimContent(ContentType);

-------------------------------------------------------------
-- Dimension: Calendar Date
-------------------------------------------------------------
CREATE TABLE sw.DimDate (
    DateID     INT        NOT NULL PRIMARY KEY,  -- yyyymmdd format
    FullDate   DATE       NOT NULL UNIQUE,
    [Year]     SMALLINT   NOT NULL,
    [Month]    TINYINT    NOT NULL CHECK ([Month] BETWEEN 1 AND 12),
    [Day]      TINYINT    NOT NULL CHECK ([Day]   BETWEEN 1 AND 31),
    WeekOfYear TINYINT    NULL
);
CREATE INDEX IX_DimDate_YearMonth ON sw.DimDate([Year],[Month]);

-------------------------------------------------------------
-- Dimension: Time of Day (Decision Context)
-------------------------------------------------------------
CREATE TABLE sw.DimTimeOfDay (
    TimeBucketID  INT IDENTITY(1,1) PRIMARY KEY,
    BucketName    VARCHAR(20) NOT NULL UNIQUE
        CHECK (BucketName IN ('Morning','Afternoon','Evening','Late Night'))
);

-------------------------------------------------------------
-- Fact: View Session (Core Analysis Table)
-------------------------------------------------------------
CREATE TABLE sw.FactViewSession
(
    SessionID         BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserID            INT NOT NULL REFERENCES sw.DimUserProfile(UserID),
    ContentID         INT NULL REFERENCES sw.DimContent(ContentID),
    DateID            INT NOT NULL REFERENCES sw.DimDate(DateID),
    TimeBucketID      INT NOT NULL REFERENCES sw.DimTimeOfDay(TimeBucketID),

    ScrollDurationSec INT NOT NULL CHECK (ScrollDurationSec >= 0),
    WatchDurationMin  INT NOT NULL CHECK (WatchDurationMin >= 0),

    RecommendationType VARCHAR(25) NOT NULL CHECK (RecommendationType IN ('Continue Watching','Top Picks','Trending Now','Because You Watched')),

    DidUserWatch      BIT NOT NULL,
    SatisfactionScore TINYINT NULL CHECK (SatisfactionScore BETWEEN 1 AND 5),

    InsertedAt        DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE INDEX IX_FactViewSession_UserDate ON sw.FactViewSession(UserID,DateID);
