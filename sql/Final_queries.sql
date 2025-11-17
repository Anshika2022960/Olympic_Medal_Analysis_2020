----- Medals Summary
-- Top 10 countries by total medals

CREATE OR REPLACE TABLE ANALYTICS.MEDALS_Summary AS
SELECT
 TRIM("Team/NOC")                    AS TEAM_NOC,        -- keep as a single text field
  TRY_TO_NUMBER(Gold)                AS GOLD,
  TRY_TO_NUMBER(Silver)              AS SILVER,
  TRY_TO_NUMBER(Bronze)              AS BRONZE,
  TRY_TO_NUMBER(Total)               AS TOTAL,
  RANK                               AS RANK_NUMBER,
  "Rank by Total"                    AS Rank_by_Total
   
FROM RAW.MEDALS
limit 10;
SELECT * FROM ANALYTICS.MEDALS_Summary


---- Medal Count per Team × Sport

USE DATABASE CLOUDLOAD_DB;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE TABLE ANALYTICS.MEDAL_TEAM_CLEAN AS
SELECT
    t.NOC                                  AS NOC,
    COALESCE(m.GOLD,   0)                  AS GOLD,
    COALESCE(m.SILVER, 0)                  AS SILVER,
    COALESCE(m.BRONZE, 0)                  AS BRONZE,
    COALESCE(m.TOTAL,  0)                  AS TOTAL_MEDALS,
    INITCAP(t.Event)                       AS EVENT
FROM ANALYTICS.MEDALS_CLEAN m
JOIN RAW.TEAMS t
      ON UPPER(m.Team_NOC) = UPPER(t.NOC);



SELECT count(event) 
FROM ANALYTICS.MEDAL_TEAM_CLEAN
WHERE EVENT IS NULL;

---- MEDAL PER TEAM

CREATE OR REPLACE TABLE ANALYTICS.MEDAL_TEAM AS
SELECT
  m.TEAM_NOC                   AS TEAM,            
  t.NOC,
  m.GOLD,
  m.SILVER,
  m.BRONZE,
  m.TOTAL        AS TOTAL_MEDALS,
  m.RANK_NUMBER,
  m.RANK_BY_TOTAL
FROM ANALYTICS.MEDALS_CLEAN m
LEFT JOIN ANALYTICS.TEAMS_CLEAN t
    ON UPPER(t.NOC)    = UPPER(m.TEAM_NOC);
 



--- Simple BI View

---Leaderboard (team level):

CREATE OR REPLACE VIEW ANALYTICS.TEAM_LEADERBOARD AS
SELECT DISTINCT TEAM, COALESCE(NOC,'') AS NOC,
       GOLD, SILVER, BRONZE, TOTAL_MEDALS,
       RANK_NUMBER, RANK_BY_TOTAL
FROM ANALYTICS.MEDAL_TEAM
ORDER BY GOLD DESC, SILVER DESC, BRONZE DESC;

SELECT * 
FROM ANALYTICS.TEAM_LEADERBOARD


---- Show athletes whose team/NOC has at least one Gold medal, plus their coach, NOC, and discipline.


WITH athlete_coach AS (
    SELECT
        a.Name AS ATHLETE_NAME,
        COALESCE(c.Name, 'No coach listed') AS COACH_NAME,
        a.NOC,
        a.Discipline AS DISCIPLINE,
        m.GOLD,
        ROW_NUMBER() OVER (
            PARTITION BY a.Name, a.NOC, a.Discipline
            ORDER BY c.Name
        ) AS rn
    FROM RAW.ATHLETES a
    JOIN RAW.TEAMS t
        ON UPPER(a.NOC) = UPPER(t.NOC)
    LEFT JOIN RAW.COACHES c
        ON UPPER(c.NOC) = UPPER(a.NOC)
       AND UPPER(c.Discipline) = UPPER(a.Discipline)
    JOIN ANALYTICS.MEDALS_CLEAN m
        ON UPPER(m.TEAM_NOC) = UPPER(t.NOC)
    WHERE m.GOLD > 0
)
SELECT
    ATHLETE_NAME,
    COACH_NAME,
    NOC,
    DISCIPLINE,
    GOLD
FROM athlete_coach
WHERE rn = 1;      -- keep only one coach per athlete


-----Query: Athlete name, NOC, discipline, gender, NOC medal total

CREATE OR REPLACE TABLE ANALYTICS.NOC_DISCIPLINE_GENDER_MEDALS AS
SELECT DISTINCT
    a.NOC,
    a.Discipline,
    e.Female AS TOTAL_FEMALE_IN_SPORT,
    e.Male   AS TOTAL_MALE_IN_SPORT,
    m.GOLD,
    m.SILVER,
    m.BRONZE
FROM RAW.ATHLETES a
LEFT JOIN RAW.ENTRIES_GENDER e
      ON UPPER(a.Discipline) = UPPER(e.Discipline)
JOIN ANALYTICS.MEDALS_CLEAN m
      ON UPPER(m.TEAM_NOC) = UPPER(a.NOC)
WHERE m.GOLD > 0 OR m.SILVER > 0 OR m.BRONZE > 0;



---Athletes with GOLD NOC

CREATE OR REPLACE TABLE ANALYTICS.ATHLETES_GOLD_NOC AS
SELECT DISTINCT
    a.Name AS ATHLETE_NAME,
    COALESCE(c.Name, 'No coach listed') AS COACH_NAME,
    t.NOC  AS NOC,
    a.Discipline  AS DISCIPLINE,
    m.GOLD
FROM RAW.ATHLETES a
JOIN RAW.TEAMS t
      ON a.NOC = t.NOC
LEFT JOIN RAW.COACHES c
      ON c.Discipline = a.Discipline
JOIN ANALYTICS.MEDALS_CLEAN m
      ON UPPER(m.TEAM_NOC) = UPPER(t.NOC)
WHERE m.GOLD > 0;
