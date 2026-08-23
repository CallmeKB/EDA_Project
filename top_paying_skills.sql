
/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/

SELECT
    sd.skills,
    FORMAT('{:,.2f}', median(salary_year_avg)) AS average_salary,
    COUNT(jpf.salary_year_avg) AS job_count
    
FROM job_postings_fact as jpf
JOIN skills_job_dim as sjd
    ON jpf.job_id = sjd.job_id
JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE lower(jpf.job_title_short) LIKE '%data engineer%'
GROUP BY sd.skills
HAVING COUNT(jpf.salary_year_avg) >100
ORDER BY MEDIAN(jpf.salary_year_avg) DESC
LIMIT 20;


/*
┌────────────┬────────────────┬───────────┐
│   skills   │ average_salary │ job_count │
│  varchar   │    varchar     │   int64   │
├────────────┼────────────────┼───────────┤
│ mongo      │ 176,500.00     │       467 │
│ cassandra  │ 166,500.00     │       846 │
│ puppet     │ 157,500.00     │       108 │
│ golang     │ 155,000.00     │       144 │
│ redis      │ 155,000.00     │       161 │
│ kafka      │ 150,000.00     │      2941 │
│ shell      │ 150,000.00     │      1113 │
│ c          │ 150,000.00     │       273 │
│ typescript │ 149,506.00     │       118 │
│ ansible    │ 147,548.25     │       238 │
│ splunk     │ 147,500.00     │       132 │
│ kubernetes │ 147,500.00     │      1258 │
│ hadoop     │ 147,500.00     │      2727 │
│ redshift   │ 147,500.00     │      2485 │
│ gdpr       │ 147,500.00     │       190 │
│ pytorch    │ 147,500.00     │       167 │
│ graphql    │ 147,500.00     │       118 │
│ terraform  │ 147,500.00     │       938 │
│ airflow    │ 147,500.00     │      2304 │
│ scala      │ 147,500.00     │      2783 │
└────────────┴────────────────┴───────────┘
  20 rows                       3 columns */