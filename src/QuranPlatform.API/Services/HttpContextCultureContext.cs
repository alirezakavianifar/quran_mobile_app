using System.Globalization;
using Microsoft.AspNetCore.Localization;
using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.API.Services;

public class HttpContextCultureContext : ICultureContext
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public HttpContextCultureContext(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public string CurrentCultureName
    {
        get
        {
            var httpContext = _httpContextAccessor.HttpContext;
            if (httpContext == null) return "fa-IR";

            var feature = httpContext.Features.Get<IRequestCultureFeature>();
            if (feature?.RequestCulture?.Culture != null)
            {
                return feature.RequestCulture.Culture.Name;
            }

            return CultureInfo.CurrentCulture.Name ?? "fa-IR";
        }
    }
}
