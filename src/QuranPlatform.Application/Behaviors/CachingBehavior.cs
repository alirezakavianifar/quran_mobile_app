using System.Text.Json;
using MediatR;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Logging;
using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.Application.Behaviors;

public class CachingBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : ICacheableQuery
{
    private readonly IDistributedCache _cache;
    private readonly ICultureContext _cultureContext;
    private readonly ILogger<CachingBehavior<TRequest, TResponse>> _logger;

    public CachingBehavior(IDistributedCache cache, ICultureContext cultureContext, ILogger<CachingBehavior<TRequest, TResponse>> logger)
    {
        _cache = cache;
        _cultureContext = cultureContext;
        _logger = logger;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        var culturePrefix = _cultureContext.IsPersian ? "fa" : "en";
        var fullCacheKey = $"quran:{culturePrefix}:{request.CacheKey}";

        var cachedBytes = await _cache.GetAsync(fullCacheKey, cancellationToken);
        if (cachedBytes != null && cachedBytes.Length > 0)
        {
            _logger.LogInformation("Cache hit for key {CacheKey}", fullCacheKey);
            var deserialized = JsonSerializer.Deserialize<TResponse>(cachedBytes);
            if (deserialized != null)
            {
                return deserialized;
            }
        }

        _logger.LogInformation("Cache miss for key {CacheKey}", fullCacheKey);
        var response = await next();

        if (response != null)
        {
            var options = new DistributedCacheEntryOptions
            {
                AbsoluteExpirationRelativeToNow = request.CacheExpiration ?? TimeSpan.FromMinutes(10)
            };
            var serialized = JsonSerializer.SerializeToUtf8Bytes(response);
            await _cache.SetAsync(fullCacheKey, serialized, options, cancellationToken);
        }

        return response;
    }
}
