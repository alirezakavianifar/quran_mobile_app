namespace QuranPlatform.Application.Common.Interfaces;

public interface ICacheableQuery
{
    string CacheKey { get; }
    TimeSpan? CacheExpiration => TimeSpan.FromMinutes(10);
}
