namespace QuranPlatform.Application.Sync.DTOs;

public record SyncBookmarkDto(string VerseKey, DateTime Timestamp, string? Folder = null);
public record SyncHighlightDto(string VerseKey, string ColorHex, DateTime Timestamp);
public record SyncNoteDto(string VerseKey, string NoteText, DateTime Timestamp);
public record SyncReadingHistoryDto(string VerseKey, int PageNumber, DateTime Timestamp);

public record SyncPayloadDto(
    string UserId,
    List<SyncBookmarkDto>? Bookmarks = null,
    List<SyncHighlightDto>? Highlights = null,
    List<SyncNoteDto>? Notes = null,
    List<SyncReadingHistoryDto>? ReadingHistory = null,
    DateTime? LastSyncedAt = null
);

public record SyncResultDto(
    bool Success,
    string UserId,
    DateTime SyncedAt,
    int ItemsProcessed,
    string Message
);
