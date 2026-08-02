# Implementation Plan - AI Assistant API Connection & Web App Verification

Ensure the **دستیار هوشمند قرآن (AI Assistant)** in the Quran Mobile Web App is properly connected to the backend API (`/api/v1/ai/ask`) and functions seamlessly with real grounded responses and citations.

## User Review Required

> [!IMPORTANT]
> 1. **Port Synchronization**: The Flutter app `DioHttpClient` was defaulting to `http://localhost:5000`, while the backend API runs on `http://localhost:5153`. This was causing direct connection failures on API calls.
> 2. **Type Parsing Fix**: `ai_chat_provider.dart` previously attempted `List<String>.from(data['citations'])`, which threw a runtime exception when receiving `GroundedCitation` objects (`{surahId, verseNumber, ...}`) from the .NET backend API, forcing it into offline fallback mode.

## Proposed Changes

### 1. Flutter Mobile/Web App (`src/quran_mobile_app`)

#### [MODIFY] [dio_http_client.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/core/network/dio_http_client.dart)
- Change default `baseUrl` from `http://localhost:5000` to `http://localhost:5153`.

#### [MODIFY] [ai_chat_provider.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/features/ai_chat/ai_chat_provider.dart)
- Enhance `sendQuestion` to robustly parse backend API responses (`answer` / `Answer`, `citations` / `Citations`).
- Parse `GroundedCitation` objects into human-readable citation tags (e.g. `[سوره ۲:۲۵۵]` / `[Surah 2:255]`) or raw text strings.

### 2. Implementation Plan Documentation

#### [NEW] [ai_assistant_integration_plan.md](file:///e:/projects/quran_mobile_app/docs/ai_assistant_integration_plan.md)
- Store permanent documentation for this phase in `docs/`.

---

## Verification Plan

### Automated Tests
- Run `flutter test` in `src/quran_mobile_app` to verify no regressions in Flutter test suite.

### Manual Verification
1. Start backend server: `dotnet run --project src/QuranPlatform.API/QuranPlatform.API.csproj --urls http://localhost:5153`
2. Test backend API endpoint directly: Send HTTP POST to `http://localhost:5153/api/v1/ai/ask` with `{"question": "آیه الکرسی"}`.
3. Launch Flutter Web app: `flutter run -d chrome` (or `flutter run -d web-server --web-port 8080`).
4. Open web browser subagent or inspect in browser:
   - Navigate to **دستیار هوشمند قرآن** (AI Assistant tab).
   - Submit a Persian question (e.g., "نور و تسبیح در قرآن به چه معناست؟").
   - Confirm answer is received from API with citations displayed as badges.
   - Switch language to English and test asking a question in English.
