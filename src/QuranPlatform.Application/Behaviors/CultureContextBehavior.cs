using System.Globalization;
using MediatR;
using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.Application.Behaviors;

public class CultureContextBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : notnull
{
    private readonly ICultureContext _cultureContext;

    public CultureContextBehavior(ICultureContext cultureContext)
    {
        _cultureContext = cultureContext;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        var culture = _cultureContext.IsPersian ? new CultureInfo("fa-IR") : new CultureInfo("en-US");
        CultureInfo.CurrentCulture = culture;
        CultureInfo.CurrentUICulture = culture;

        return await next();
    }
}
