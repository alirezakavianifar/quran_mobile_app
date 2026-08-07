# Smart Surah Query Resolution in RAG Retrieval Engine

Implement intelligent Surah ordinal and number query resolution in `RagEngine` so queries referencing specific Surahs by number or Persian ordinal (such as *"سوره بیستم قرآن"*, *"سوره ۲۰"*, *"Surah 20"*, *"سوره اول"*) automatically hydrate context with verses from the exact target Surah (e.g. Surah 20: Ta-Ha), avoiding substring search mis-matches.

## Proposed Changes

1. **`SurahQueryDetector`**: Parse Persian/English digits and Persian ordinals ("اول" through "صد و چهاردهم" / "بیستم") to detect target `surahId` (1..114).
2. **`RagEngine.cs`**: In `HydrateContextAsync`, check `SurahQueryDetector.DetectSurahNumber(question)` to directly retrieve verses of the target Surah when specified.
3. **Unit Tests**: Add tests in `SurahQueryDetectorTests.cs` and `RagEngineTests.cs`.

## Verification Plan

- Run `dotnet test QuaranPlatform.slnx`.
- Verify response for `POST /api/v1/ai/ask` with question *"سوره بیستم قرآن"*.
