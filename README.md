# Data Engineer Job-Market Analysis

A focused SQL analytics project that examines which skills matter most for data-engineering roles. Using job-posting data in a star-schema warehouse, it answers three practical questions: which skills are requested most often, which command the highest pay, and which offer the strongest balance of demand and compensation.

## Highlights

- Analyses remote and general Data Engineer job postings with DuckDB SQL.
- Uses fact, dimension, and bridge tables to model skills attached to job postings.
- Demonstrates joins, aggregation, window functions, filtering, median salary analysis, and a calculated ranking metric.
- Produces actionable learning priorities across programming, cloud, orchestration, warehousing, and infrastructure tooling.

## Questions answered

| Analysis | Business question | Output |
| --- | --- | --- |
| [Top demanded skills](top_demanded_skills.sql) | Which skills occur most often in remote Data Engineer postings? | Top 20 skills ranked by posting count |
| [Top paying skills](top_paying_skills.sql) | Which skills have the highest median annual salary? | Top 20 skills with median salary and qualifying-posting count |
| [Optimal skills](top_optimal_skills.sql) | Which skills balance salary with meaningful market demand? | Top 25 skills ranked by a demand-adjusted salary score |

## Data model

The analysis expects a job-postings warehouse with the following relationships:

```text
job_postings_fact
    │
    ├──< skills_job_dim >── skills_dim
    │
    └── company_dim (conceptual relationship; not used by the current queries)
```

| Table | Role | Fields used in this project |
| --- | --- | --- |
| `job_postings_fact` | Central job-posting fact table | `job_id`, `job_title_short`, `job_work_from_home`, `salary_year_avg` |
| `skills_job_dim` | Bridge table linking postings to skills | `job_id`, `skill_id` |
| `skills_dim` | Skill lookup table | `skill_id`, `skills` |
| `company_dim` | Company lookup table | Documented as part of the wider warehouse; not queried here |

A posting can require many skills, and a skill can occur in many postings. The `skills_job_dim` bridge resolves that many-to-many relationship.

## Getting started

### Prerequisites

- [DuckDB](https://duckdb.org/) 1.x or later
- A DuckDB database containing the three tables above
- A dataset with populated job title, work-from-home, skill, and—where salary analysis is needed—annual salary fields

### Run an analysis

Open DuckDB against your database, then execute a script:

```bash
duckdb job_postings.db
.read top_demanded_skills.sql
```

Replace the script name to run a different analysis. If your source dataset uses different table or column names, update the SQL accordingly.

## Methodology

### 1. Skill demand

`top_demanded_skills.sql` joins job postings to their listed skills, filters to work-from-home postings whose short title ends in “data engineer,” counts each skill occurrence, and returns the 20 most frequent results. A `ROW_NUMBER()` window function provides the displayed ranking.

Latest recorded results place **SQL** (38,368 postings) and **Python** (38,117) first and second. AWS, Azure, Spark, Airflow, Snowflake, and Databricks follow, indicating strong demand for a foundation spanning programming, cloud platforms, data processing, orchestration, and warehousing.

### 2. Salary premium

`top_paying_skills.sql` calculates **median** annual salary—not mean salary—for skills found in Data Engineer postings. It retains skills with more than 100 salary-bearing records, reducing the influence of very small samples, then returns the top 20 by median salary.

The recorded results identify Mongo, Cassandra, Puppet, Golang, Redis, Kafka, and several infrastructure/data-platform skills among the highest-paid. Salary metrics should be read alongside the included job count: a high salary paired with relatively few postings is a different career signal from a high salary at scale.

### 3. Demand-adjusted value

`top_optimal_skills.sql` focuses on remote Data Engineer postings that include annual salary data. For every skill with at least 100 linked postings, it calculates:

```text
optimal_score = ln(demand_count) × median_salary / 1,000,000
```

The natural-log transformation dampens the effect of extremely common skills, allowing both broadly useful skills and higher-paying specializations to surface. The recorded ranking places Terraform first, followed by Python, SQL, AWS, Airflow, and Spark.

## Key findings

1. **SQL and Python are the core foundation.** They lead the remote-demand ranking and remain near the top when compensation is considered.
2. **Cloud is essential.** AWS, Azure, and GCP appear frequently, while cloud-warehouse and platform tools such as Snowflake, Databricks, Redshift, and BigQuery add depth.
3. **Pipeline and big-data skills are highly relevant.** Spark, Airflow, Kafka, Hadoop, and PySpark recur across the demand and optimal-skill outputs.
4. **Infrastructure specialization can improve earning potential.** Terraform, Kubernetes, Docker, and related tooling carry strong salary signals, although some have lower demand than the foundational skills.
5. **Prioritise combinations, not isolated technologies.** A practical progression is SQL + Python → cloud and warehousing → orchestration/streaming → infrastructure specialisation.

## SQL techniques demonstrated

- Multi-table `JOIN` operations across fact, dimension, and bridge tables
- `COUNT()`, `MEDIAN()`, `ROUND()`, and `FORMAT()` aggregations
- Window-function ranking with `ROW_NUMBER()`
- Filter conditions for role, remote status, and available salary data
- `GROUP BY`, `HAVING`, `ORDER BY`, and `LIMIT`
- Logarithmic normalization with `LN()`
- A calculated score that combines demand and compensation

## Important interpretation notes

- The included results are snapshots of the underlying job-posting dataset. Re-run the scripts after updating the data.
- The demand script uses a case-insensitive title match, while the salary and optimal-skill scripts use the `Data Engineer` short-title category. Align these filters if strict comparability is required.
- The salary query’s output alias is `average_salary`, but the calculation is a **median**. The value should therefore be interpreted as median annual salary.
- Demand counts measure skill mentions in qualifying postings, not distinct employers, applicants, or job openings.
- The optimal score is a decision-support heuristic, not a causal estimate of a skill’s salary impact.

## Repository layout

```text
EDA_Project/
├── README.md
├── top_demanded_skills.sql
├── top_paying_skills.sql
└── top_optimal_skills.sql
```

## Future improvements

- Add the dataset source, acquisition steps, schema DDL, and data-refresh date.
- Add query parameters for role, geography, remote status, and minimum sample size.
- Standardize title filters and rename `average_salary` to `median_salary`.
- Add charts or a dashboard to make results easier to compare.
- Add tests or validation queries for row counts, null rates, and join cardinality.

## Author

Created by [Kaushal Bohara](https://github.com/CallmeKB).
