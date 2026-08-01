namespace QuranPlatform.Application.Common.Interfaces;

public interface ICultureContext
{
    string CurrentCultureName { get; }
    bool IsPersian => CurrentCultureName.StartsWith("fa", StringComparison.OrdinalIgnoreCase);
}
