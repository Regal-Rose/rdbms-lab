# RDBMS Lab Practicals

A collection of SQL practicals demonstrating relational database concepts and their implementation using **MySQL 8.0+**. This repository contains practical exercises covering schema design, integrity constraints, SQL queries, normalization, transaction management, indexing, and query optimization.

## 📚 Experiments

| Experiment | Topic | Key Concepts |
|---|---|---|
| 1 | RDBMS Fundamentals | Introductory practical documentation (PDF) |
| 2 | Relational Schema and Integrity Constraints | Primary keys, foreign keys, constraints, referential integrity |
| 3 | SQL Queries and Aggregation | Filtering, sorting, aggregate functions, `GROUP BY`, `HAVING` |
| 4 | Joins, Subqueries and Execution Plans | Joins, correlated subqueries, `EXPLAIN` |
| 5 | Views and Recursive Queries | Views, view updatability, recursive CTEs |
| 6 | Stored Procedures and Triggers | Stored procedures, validation triggers, audit logging |
| 7 | Database Normalization | Functional dependencies, 1NF, 2NF, 3NF, BCNF, lossless decomposition |
| 8 | Transaction Management and Concurrency | `COMMIT`, `ROLLBACK`, `SAVEPOINT`, isolation levels, concurrency anomalies |
| 9 | Indexing and Performance Benchmarking | Single-column indexes, composite indexes, query execution plans |
| 10 | Query Optimization | Dataset generation, query rewriting, indexing, execution-time comparison |

## 🛠️ Technologies

- **Database:** MySQL 8.0+
- **Language:** SQL
- **Recommended GUI:** MySQL Workbench
- **Version control:** Git and GitHub

## ⚙️ Prerequisites

Before running the experiments, install:

1. MySQL Server 8.0 or later.
2. MySQL Workbench or another compatible SQL client.
3. Git, if you want to clone the repository locally.

Some features, including `EXPLAIN ANALYZE`, require specific MySQL versions. Check the comments in each SQL file for additional requirements.

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Regal-Rose/rdbms-lab.git
cd rdbms-lab
```

### 2. Open an experiment

Open the required `ExperimentN.sql` file in MySQL Workbench, where `N` is the experiment number.

### 3. Execute the SQL script

Connect to your MySQL server and execute the script. Follow any instructions in the comments, especially for experiments that require multiple sessions or selected statements to be run separately.

Alternatively, run a script from the terminal:

```bash
mysql -u your_username -p < Experiment2.sql
```

Replace `Experiment2.sql` with the required filename.

**Note:** The scripts may create databases and tables, insert sample data, or drop and recreate tables. Review the statements before executing them against any database containing important data.

## 📖 Learning Outcomes

By completing these practicals, you can learn to:

- Design relational schemas and enforce data integrity.
- Write SQL queries using joins, subqueries, aggregate functions, and views.
- Apply normalization techniques and analyze functional dependencies.
- Implement stored procedures, triggers, and audit mechanisms.
- Manage transactions and understand concurrency control.
- Use indexes and execution plans to investigate query performance.
- Compare query execution before and after optimization.

## 📂 Repository Structure

```text
rdbms-lab/
├── Experiment1.pdf
├── Experiment2.sql
├── Experiment3.sql
├── Experiment4.sql
├── Experiment5.sql
├── Experiment6.sql
├── Experiment7.sql
├── Experiment8.sql
├── Experiment9.sql
├── Experiment10.sql
└── README.md
```

## 👩‍💻 Contributing

Suggestions, corrections, and improvements are welcome. When contributing, keep SQL scripts readable, add comments where necessary, and specify any MySQL version requirements.

## 📄 License

No license is currently specified. Unless a license is added to the repository, reuse and redistribution are subject to the applicable copyright rules.

---

**Repository:** [Regal-Rose/rdbms-lab](https://github.com/Regal-Rose/rdbms-lab)

*Built for learning, practicing, and revising Relational Database Management Systems.*
