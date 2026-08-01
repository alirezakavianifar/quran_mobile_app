namespace QuranPlatform.Domain.ValueObjects;

public readonly record struct PreferredCulture
{
    public string CultureCode { get; }

    public static readonly PreferredCulture Persian = new PreferredCulture("fa-IR");
    public static readonly PreferredCulture English = new PreferredCulture("en-US");

    public PreferredCulture(string cultureCode)
    {
        if (string.IsNullOrWhiteSpace(cultureCode))
        {
            CultureCode = "fa-IR";
            return;
        }

        CultureCode = cultureCode.StartsWith("fa", StringComparison.OrdinalIgnoreCase) ? "fa-IR" : "en-US";
    }

    public bool IsPersian => CultureCode.Equals("fa-IR", StringComparison.OrdinalIgnoreCase);
    public string TextDirection => IsPersian ? "rtl" : "ltr";

    public override string ToString() => CultureCode;
}
