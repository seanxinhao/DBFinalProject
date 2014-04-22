---------------------------PART D REPORT
-- Format
SET FEEDBACK OFF LINESIZE 160 PAGESIZE 40
BREAK ON REPORT ON DEPARTMENT SKIP 1
COLUMN PROJECT FORMAT A50
COLUMN DEPARTMENT FORMAT A25
COLUMN "TOTAL COST" FORMAT $9999999
COLUMN "COST PER HOUR" FORMAT A15
COLUMN DURATION HEADING 'DURATION | (IN HOURS)'
COLUMN "HOURLY COST PER PERSON" HEADING 'HOURLY COST | PER PERSON'
-- Compute Format
COMPUTE SUM LABEL "TOTAL DEPARTMENT COST" OF  "TOTAL COST" ON DEPARTMENT
-- Header and footer
TTITLE 'TOTAL COST PER DEPARTMENT | FROM JANUARY 1, 2011 TO DECEMBER 31, 2014'
BTITLE CENTER 'END OF REPORT' - RIGHT 'RUN BY: ' SQL.USER FORMAT A7
SPOOL "D:\DBM\FP\PARTDRESULTS.TXT"
-- SQL query
SELECT DEPARTMENT.NAME AS DEPARTMENT, PROJECT.NAME AS PROJECT,
	SUM(HOURS_USED) AS DURATION,
	TOTAL_COST "TOTAL COST", COUNT(EMP_NUM) "EMPLOYEES#",
	TO_CHAR(TOTAL_COST/SUM(HOURS_USED), '$9999999') "COST PER HOUR",
	TO_CHAR(TOTAL_COST/SUM(HOURS_USED)/COUNT(EMP_NUM), '$9999999.99') "HOURLY COST PER PERSON"
FROM DEPARTMENT JOIN PROJECT USING (DEPT_CODE)
	JOIN ASSIGNMENT USING (PROJ_NUMBER)
WHERE PROJECT.START_DATE > TO_DATE('1-JAN-2011','DD-MON-YYYY')     
GROUP BY DEPARTMENT.NAME, PROJECT.NAME, PROJECT.START_DATE, TOTAL_COST
HAVING MAX(ASSIGNMENT.DATE_ENDED) < TO_DATE('31-DEC-2014','DD-MON-YYYY')
ORDER BY DEPARTMENT, TOTAL_COST DESC;
-- End SQL query
SPOOL OUT
