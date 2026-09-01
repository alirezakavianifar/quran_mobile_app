# Implementation Plan: GitHub Actions Quota, Cost & Speed Optimization

Drastically reduce GitHub Actions runner minutes consumption (especially expensive macOS runner minutes), optimize cache and artifact storage, eliminate duplicate runs, and add concurrency cancellation.

## 1. Problem Analysis & Inefficiencies Identified

Inspection of the repository's current workflows revealed major quota drains:

1. **Duplicate Android APK Compilations on Every Push**:
   - Both `.github/workflows/build-apk.yml` and `.github/workflows/build-mobile.yml` triggered on push to `master`.
   - Every single push compiled two identical release APKs in parallel on two separate Ubuntu runners!

2. **10× Multiplier Drain from macOS Runner (`macos-latest`)**:
   - In `build-mobile.yml`, the `build-ios` job was set to run on every `push` to `master`!
   - Standard macOS runners on GitHub cost **$0.062/minute** (a **10× billing multiplier** against the 2,000 free monthly quota for private repositories).
   - An iOS job taking 15 minutes burns **150 minutes** per push. Just ~13 pushes would completely deplete the entire monthly quota!

3. **No Path Filtering on `build-apk.yml` and `ci-cd.yml`**:
   - Any commit touching documentation (`README.md`, `docs/**`), scripts, or tests triggered 45-minute APK compilation pipelines.

4. **Missing Concurrency Controls (`cancel-in-progress`)**:
   - Pushing 3 commits in rapid succession queued up 3 full runs of every workflow without canceling superseded builds.

5. **Storage Quota Depletion**:
   - Artifacts were retained for `14` days. Since GitHub Free provides 500 MB shared storage, keeping multiple 100MB+ APKs/IPAs quickly fills up the quota.

---

## 2. Optimization Strategy & Proposed Solutions

### A. Concurrency & Automatic Cancellation
Add concurrency groups to all 4 workflows:
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```
When you push new commits while a previous run is still building, GitHub immediately cancels the old, obsolete run, saving 10–30 minutes per superseded commit.

### B. Eliminate Redundant Triggers & Restrict macOS Runner
- Change `build-mobile.yml` so that `build-ios` runs **only** on manual trigger (`workflow_dispatch`):
  ```yaml
  if: ${{ github.event_name == 'workflow_dispatch' }}
  ```
  This single change alone saves **~1,000 to 1,800 minutes/month**!
- Set `build-apk.yml` to trigger only on `workflow_dispatch` (dedicated APK distribution pipeline) while `build-mobile.yml` handles automated push builds, or vice versa, eliminating duplicate compilation.

### C. Granular Path Filtering & Path Ignore
Only trigger builds when relevant code changes:
- Mobile workflows: only when `src/quran_mobile_app/**` or mobile workflows change, ignoring `**/*.md`, `docs/**`, `scripts/**` (except app scripts).
- Deploy server: only when `src/QuranPlatform.**`, `docker-compose.yml`, `sql/**` change.
- CI/CD: ignore all documentation changes (`docs/**`, `*.md`).

### D. Caching for Pip, DotNet & Gradle
- Python: `actions/setup-python@v5` with `cache: 'pip'`.
- .NET: `actions/setup-dotnet@v4` with `cache: true`.
- Gradle: Use `gradle/actions/setup-gradle@v3` or native Gradle caching to cache dependencies, cutting build times by 50–70%.

### E. Storage Retention Reduction
Change all `upload-artifact` steps from `retention-days: 14` to `retention-days: 3`, preventing storage overage on GitHub Free (500 MB limit).

---

## 3. Step-by-Step Implementation Steps

1. **Update `.github/workflows/build-apk.yml`**:
   - Set trigger to `workflow_dispatch` only (so it functions as a dedicated on-demand build/distribution pipeline with Rubika bot delivery without firing on every small push).
   - Add concurrency control.
   - Reduce artifact retention to 3 days.
2. **Update `.github/workflows/build-mobile.yml`**:
   - Add path filtering: `src/quran_mobile_app/**`, ignore `**/*.md`, `docs/**`.
   - Add concurrency control.
   - Restrict `build-ios` to `github.event_name == 'workflow_dispatch'`.
   - Add pip cache.
   - Reduce artifact retention to 3 days.
3. **Update `.github/workflows/ci-cd.yml`**:
   - Add path ignore for `docs/**`, `**/*.md`.
   - Add concurrency control.
   - Add pip caching and .NET caching.
4. **Update `.github/workflows/deploy-server.yml`**:
   - Add concurrency control.
   - Maintain strict path filtering.
