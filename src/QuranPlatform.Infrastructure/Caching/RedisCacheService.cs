using System.Text.Json;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Logging;

namespace QuranPlatform.Infrastructure.Caching;

public class RedisCacheService
{
    private readonly IDistributedCache _cache;
    private readonly ILogger<RedisCacheService> _logger;

    public RedisCacheService(IDistributedCache cache, ILogger<RedisCacheService> logger)
    {
        _cache = cache;
        _logger = logger;
    }

    public async Task<T?> GetAsync<T>(string key, CancellationToken ct = default)
    {
        try
        {
            var bytes = await _cache.GetAsync(key, ct);
            if (bytes == null || bytes.Length == 0) return default;
            return JsonSerializer.Deserialize<T>(bytes);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Cache get failure for key {Key}", key);
            return default;
        }
    }

    public async Task SetAsync<T>(string key, T value, TimeSpan? expiration = null, CancellationToken ct = default)
    {
        try
        {
            var options = new DistributedCacheEntryOptions
            {
                AbsoluteExpirationRelativeToNow = expiration ?? TimeSpan.FromMinutes(10)
            };
            var bytes = JsonSerializer.SerializeToUtf8Bytes(value);
            await _cache.SetAsync(key, bytes, options, ct);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Cache set failure for key {Key}", key);
        }
    }
}
