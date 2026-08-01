namespace QuranPlatform.Domain.Entities;

public class UserSettings
{
    public Guid UserId { get; set; }
    public string PreferredLanguage { get; set; } = "fa"; // 'fa' default (Persian), 'en' (English)
    public string SecondaryLanguage { get; set; } = "en";
    public int? DefaultTranslationId { get; set; }
    public int? DefaultTafsirId { get; set; }
    public string TextDirection { get; set; } = "rtl";
    public string FontFamily { get; set; } = "Vazirmatn";
    public int QuranFontSize { get; set; } = 22;
    public int TranslationFontSize { get; set; } = 16;

    public User? User { get; set; }
}
