namespace QuranPlatform.Domain.Entities;

public class Tafsir
{
    public int Id { get; set; }
    public int TafsirEditionId { get; set; }
    public int VerseId { get; set; }
    public int VolumeNumber { get; set; }
    public string ContentText { get; set; } = string.Empty;

    public Verse? Verse { get; set; }
}
