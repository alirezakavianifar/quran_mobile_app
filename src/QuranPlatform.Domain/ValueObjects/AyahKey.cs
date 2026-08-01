namespace QuranPlatform.Domain.ValueObjects;

public readonly record struct AyahKey(int SurahId, int VerseNumber)
{
    public override string ToString() => $"{SurahId}:{VerseNumber}";

    public static AyahKey Parse(string key)
    {
        if (string.IsNullOrWhiteSpace(key))
        {
            throw new ArgumentException("AyahKey cannot be null or empty.", nameof(key));
        }

        var parts = key.Split(':');
        if (parts.Length != 2 || !int.TryParse(parts[0], out var s) || !int.TryParse(parts[1], out var v) || s < 1 || s > 114 || v < 1)
        {
            throw new ArgumentException($"Invalid AyahKey format '{key}'. Expected format 'SurahId:VerseNumber' (e.g. 2:255).", nameof(key));
        }

        return new AyahKey(s, v);
    }
}
