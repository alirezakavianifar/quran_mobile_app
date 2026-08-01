namespace QuranPlatform.Domain.Entities;

public class Surah
{
    public int Id { get; set; }
    public int Number { get; set; }
    public string NameArabic { get; set; } = string.Empty;
    public string NamePersian { get; set; } = string.Empty;
    public string NameEnglish { get; set; } = string.Empty;
    public string RevelationType { get; set; } = string.Empty; // Makki or Madani
    public int VerseCount { get; set; }
}
