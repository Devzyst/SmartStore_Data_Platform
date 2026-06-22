# Contributing Guide

SmartStore is designed to be beginner/intermediate friendly while still looking professional.

## Simple Git Workflow

1. Create a focused branch:
   ```bash
   git checkout -b feature/add-new-analytics-query
   ```
2. Make a small, reviewable change.
3. Run checks:
   ```bash
   python -m py_compile etl/*.py data_generation/*.py
   pytest -q
   ```
4. Commit with a clear message:
   ```bash
   git commit -m "Add customer retention analytics query"
   ```
5. Open a pull request describing:
   - what changed
   - why it changed
   - how it was tested

## Contribution Ideas

- Add new SQL analytics queries.
- Improve ETL validation rules.
- Add more realistic generated fields.
- Add Power BI screenshots or dashboard notes.
- Expand tests for transformations.

## Style Guidelines

- Keep folder structure flat and easy to scan.
- Prefer one clear file per concept.
- Use descriptive SQL aliases and Python function names.
- Add comments only where they explain business or engineering intent.
