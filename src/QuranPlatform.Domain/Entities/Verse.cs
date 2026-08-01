namespace QuranPlatform.Domain.Entities;

public class Verse
{
    public int Id { get; set; }
    public int SurahId { get; set; }
    public int VerseNumber { get; set; }
    public int PageNumber { get; set; }
    public int JuzNumber { get; set; }
    public string TextUthmani { get; set; } = string.Empty;
    public string TextSimple { get; set; } = string.Empty;

    public Surah? Surah { get; set; }
    public ICollection<Translation> Translations { get; set; } = new List<Translation>();
    public ICollection<Tafsir> Tafsirs { get; set; } = new List<Tafsir>();
}
