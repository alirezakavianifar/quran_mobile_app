using System.Globalization;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Localization;
using Microsoft.EntityFrameworkCore;
using QuranPlatform.API.Hubs;
using QuranPlatform.API.Services;
using QuranPlatform.Application.AI;
using QuranPlatform.Application.Behaviors;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.Search;
using QuranPlatform.Infrastructure.AI;
using QuranPlatform.Infrastructure.Caching;
using QuranPlatform.Infrastructure.Persistence;
using QuranPlatform.Infrastructure.Persistence.Repositories;
using QuranPlatform.Infrastructure.Search;

var builder = WebApplication.CreateBuilder(args);

// 1. Add Request Localization Middleware Options (fa-IR primary default / en-US secondary)
builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    var supportedCultures = new[]
    {
        new CultureInfo("fa-IR"),
        new CultureInfo("en-US")
    };

    options.DefaultRequestCulture = new RequestCulture("fa-IR");
    options.SupportedCultures = supportedCultures;
    options.SupportedUICultures = supportedCultures;

    options.RequestCultureProviders = new IRequestCultureProvider[]
    {
        new QueryStringRequestCultureProvider(),
        new AcceptLanguageHeaderRequestCultureProvider(),
        new CookieRequestCultureProvider()
    };
});

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<ICultureContext, HttpContextCultureContext>();

// 2. Add Entity Framework Core PostgreSQL DbContext
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
    ?? "Host=localhost;Port=5432;Database=quran_db;Username=quran_admin;Password=quran_pass";

builder.Services.AddDbContext<QuranDbContext>(options =>
    options.UseNpgsql(connectionString, o => o.UseVector()));

// 3. Register Application CQRS & Pipeline Behaviors
builder.Services.AddValidatorsFromAssembly(typeof(ICultureContext).Assembly);
builder.Services.AddMediatR(cfg =>
{
    cfg.RegisterServicesFromAssembly(typeof(ICultureContext).Assembly);
    cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(CultureContextBehavior<,>));
    cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(ValidationBehavior<,>));
    cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(CachingBehavior<,>));
});

// 4. Register Infrastructure Services & Repositories
builder.Services.AddScoped<IQuranRepository, QuranRepository>();
builder.Services.AddScoped<ITafsirRepository, TafsirRepository>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<ISearchIndexRepository, OpenSearchIndexRepository>();
builder.Services.AddScoped<IVectorSearchService, VectorSearchService>();
builder.Services.AddScoped<ISearchOrchestrator, SearchOrchestrator>();
builder.Services.AddHttpClient();
builder.Services.AddScoped<IEmbeddingService, EmbeddingServiceAdapter>();
builder.Services.AddScoped<ILLMProvider, LLMProviderAdapter>();
builder.Services.AddScoped<IRagEngine, RagEngine>();

// 5. Distributed Cache & Redis Fallback
var redisConn = builder.Configuration.GetConnectionString("Redis");
if (!string.IsNullOrEmpty(redisConn))
{
    builder.Services.AddStackExchangeRedisCache(options => options.Configuration = redisConn);
}
else
{
    builder.Services.AddDistributedMemoryCache(); // Automatic in-memory fallback for local dev / Windows
}
builder.Services.AddScoped<RedisCacheService>();

// 6. Controllers, SignalR & OpenAPI/Swagger
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", p => p.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSignalR();

var app = builder.Build();

app.UseCors("AllowAll");

// Enable Localization Middleware FIRST before controllers
app.UseRequestLocalization();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.MapHub<AiChatHub>("/hubs/aichat");

app.Run();

// Make Program class accessible for Integration WebApplicationFactory tests
public partial class Program { }
