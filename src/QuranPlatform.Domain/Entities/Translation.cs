namespace QuranPlatform.Domain.Entities;

public class Translation
{
    public int Id { get; set; }
    public int VerseId { get; set; }
    public string LanguageCode { get; set; } = "fa"; // 'fa' for Persian (default), 'en' for English
    public string AuthorName { get; set; } = string.Empty; // e.g. 'Makarem Shirazi' or 'Mustafa Khattab'
    public string TranslationText { get; set; } = string.Empty;

    public Verse? Verse { get; set; }
}
