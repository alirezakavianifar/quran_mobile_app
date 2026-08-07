# Admin AI Provider Configuration & Gemini Model Update

Update backend AI model configuration to support active Gemini models (`gemini-2.5-flash`) and implement dynamic Admin API endpoints (`GET/POST /api/v1/admin/ai-provider`) allowing administrators to view and switch the active AI provider (`Gemini`, `Grok`, `Mock`) at runtime without restarting the server.

## Proposed Changes

1. **`appsettings.Development.json`**: Update Gemini model to `gemini-2.5-flash` and Grok model to `grok-2-1212`.
2. **`IAiConfigurationService` / `AiConfigurationService`**: Thread-safe singleton service managing the active AI provider state and available providers.
3. **`LLMProviderAdapter.cs`**: Consume active provider state dynamically from `IAiConfigurationService`.
4. **`AdminController.cs`**: Add `GET /api/v1/admin/ai-provider` and `POST /api/v1/admin/ai-provider` endpoints for runtime inspection and switching.
5. **Unit Tests**: Add unit tests for `AiConfigurationService`.

## Verification Plan

- Run `dotnet test src/QuaranPlatform.slnx`.
- Verify API response from `POST /api/v1/admin/ai-provider` and `POST /api/v1/ai/ask`.
