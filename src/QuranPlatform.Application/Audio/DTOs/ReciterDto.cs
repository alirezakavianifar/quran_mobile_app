namespace QuranPlatform.Application.Audio.DTOs;

public record ReciterDto(
    string Id,
    string NameArabic,
    string NamePersian,
    string NameEnglish,
    string Style,
    string BaseUrl,
    int BitrateKbps = 128
);

public record AyahAudioTimingDto(
    int SegmentIndex,
    int StartMs,
    int EndMs
);

public record AyahAudioDto(
    string ReciterId,
    int SurahId,
    int VerseNumber,
    string AudioUrl,
    int DurationMs,
    List<AyahAudioTimingDto>? WordTimings = null
);
