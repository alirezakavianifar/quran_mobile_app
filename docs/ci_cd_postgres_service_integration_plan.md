# CI/CD PostgreSQL Service Integration Plan

## Goal Description
Configure PostgreSQL with `pgvector` service containers and automated database schema/seeding in GitHub Actions `.github/workflows/ci-cd.yml` so that ASP.NET Core integration tests and Python database tests pass cleanly in the CI runner.

---

## 1. Problem Identification
In the CI runner, `dotnet test` executes integration tests (`ApiIntegrationTests.cs`) which query the PostgreSQL database (`QuranDbContext`) for Surahs and Admin stats. Without a live PostgreSQL database running in the runner, tests fail with `SocketException: Connection refused (111)`.

---

## 2. Implementation Steps
1. In `.github/workflows/ci-cd.yml`:
   - Add `services: postgres` with `image: pgvector/pgvector:pg16` to `backend-test` and `data-nlp-test`.
   - Set environment:
     - `POSTGRES_USER: quran_admin`
     - `POSTGRES_PASSWORD: quran_pass`
     - `POSTGRES_DB: quran_db`
   - Add schema initialization step: `psql -h localhost -U quran_admin -d quran_db -f sql/schema_phase1.sql`.
   - Seed database: `python scripts/ingestion/seed_postgres.py`.
   - Pass `ConnectionStrings__DefaultConnection` to `dotnet test`.

2. Verify YAML configuration and push to remote.
