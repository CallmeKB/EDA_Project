/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 20 in-demand skills for data engineers
- Focus on remote job postings
- Why? Retrieves the top 20 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for data engineers seeking remote work
*/


SELECT 
 ROW_NUMBER() OVER (ORDER BY COUNT(sjd.skill_id) DESC) AS "S.N",
sd.skills , COUNT(sjd.skill_id) as SKILL_COUNT
FROM job_postings_fact as jpf  
JOIN skills_job_dim as sjd 
    ON jpf.job_id = sjd.job_id
JOIN skills_dim AS sd  
    ON sjd.skill_id = sd.skill_id
WHERE LOWER(jpf.job_title_short) LIKE '%%data engineer' AND jpf.job_work_from_home = True
GROUP BY sd.skills,
        sjd.skill_id
ORDER BY  SKILL_COUNT DESC       
LIMIT 20;


/*
┌───────┬────────────┬─────────────┐
│  S.N  │   skills   │ SKILL_COUNT │
│ int64 │  varchar   │    int64    │
├───────┼────────────┼─────────────┤
│     1 │ sql        │       38368 │
│     2 │ python     │       38117 │
│     3 │ aws        │       24514 │
│     4 │ azure      │       18707 │
│     5 │ spark      │       17591 │
│     6 │ airflow    │       13395 │
│     7 │ snowflake  │       11781 │
│     8 │ databricks │       10962 │
│     9 │ java       │        9993 │
│    10 │ kafka      │        9315 │
│    11 │ scala      │        8779 │
│    12 │ gcp        │        8725 │
│    13 │ redshift   │        7857 │
│    14 │ hadoop     │        7323 │
│    15 │ nosql      │        6365 │
│    16 │ pyspark    │        6312 │
│    17 │ git        │        6065 │
│    18 │ docker     │        5872 │
│    19 │ kubernetes │        5848 │
│    20 │ tableau    │        5814 │
└───────┴────────────┴─────────────┘
  20 rows                3 columns
  
  
  
  
  The results show that SQL and Python are the most in-demand skills for remote Data Engineer roles, appearing in 38,368 and 38,117 job postings respectively. Cloud platforms are also highly important, with AWS leading, followed by Azure and GCP.

Data-processing and warehouse technologies—such as Spark, Snowflake, Databricks, Redshift, and Hadoop—are frequently requested, showing that Data Engineers are expected to work with large-scale data systems. Workflow and streaming skills like Airflow and Kafka are also valuable for building reliable data pipelines.

Overall, a strong remote Data Engineer skill set should prioritize SQL, Python, cloud services, big-data processing, data warehousing, and pipeline orchestration. Tools such as Docker, Kubernetes, Git, and Tableau further support deployment, collaboration, and data reporting.*/

