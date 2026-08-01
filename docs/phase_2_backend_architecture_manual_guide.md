
# Phase 2 — Backend Architecture (ASP.NET Core): Manual Execution Guide

This document provides a comprehensive, step-by-step guide to manually implement **Phase 2 (Backend Architecture)** of the Quran Knowledge Platform project.

---

## 📌 Phase 2 Overview

Phase 2 establishes an enterprise **Clean Architecture** backend using **ASP.NET Core** and **CQRS (Command Query Responsibility Segregation)** with **MediatR**.
The backend is designed with native **ASP.NET Core Request Localization**, defaulting to Persian (`fa-IR` / RTL) while supporting English (`en-US` / LTR).

```
                             QuranPlatform.API (Presentation Layer)
                           (ASP.NET Core Web API / Request Localization)
                                                 │
                                                 ▼
                       QuranPlatform.Application (Application Layer)
                        (MediatR CQRS / Pipeline Behaviors / Contracts)
                                                 │
                                                 ▼
                          QuranPlatform.Domain (Domain Layer)
                     (Entities / Value Objects / Domain Interfaces)
                                                 ▲
                                                 │
                     QuranPlatform.Infrastructure (Infrastructure Layer)
                   (EF Core PostgreSQL / Redis / OpenSearch / LLM Adapters)
```

---

## 🛠️ Step 1: Create Solution & Project Structure

Run the following PowerShell commands in the workspace root (`e:\projects\quran_mobile_app`):

```powershell
# 1. Create solution file
dotnet new sln -n QuranPlatform -o .

# 2. Create project libraries inside src/
dotnet new classlib -n QuranPlatform.Domain -o src/QuranPlatform.Domain
dotnet new classlib -n QuranPlatform.Application -o src/QuranPlatform.Application
dotnet new classlib -n QuranPlatform.Infrastructure -o src/QuranPlatform.Infrastructure
dotnet new webapi -n QuranPlatform.API -o src/QuranPlatform.API

# 3. Create test projects inside tests/
dotnet new xunit -n QuranPlatform.UnitTests -o tests/QuranPlatform.UnitTests
dotnet new xunit -n QuranPlatform.IntegrationTests -o tests/QuranPlatform.IntegrationTests

# 4. Add projects to solution
dotnet sln add src/QuranPlatform.Domain/QuranPlatform.Domain.csproj
dotnet sln add src/QuranPlatform.Application/QuranPlatform.Application.csproj
dotnet sln add src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj
dotnet sln add src/QuranPlatform.API/QuranPlatform.API.csproj
dotnet sln add tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj
dotnet sln add tests/QuranPlatform.IntegrationTests/QuranPlatform.IntegrationTests.csproj

# 5. Add project references according to Clean Architecture rules
dotnet add src/QuranPlatform.Application/QuranPlatform.Application.csproj reference src/QuranPlatform.Domain/QuranPlatform.Domain.csproj

dotnet add src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj reference src/QuranPlatform.Application/QuranPlatform.Application.csproj
dotnet add src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj reference src/QuranPlatform.Domain/QuranPlatform.Domain.csproj

dotnet add src/QuranPlatform.API/QuranPlatform.API.csproj reference src/QuranPlatform.Application/QuranPlatform.Application.csproj
dotnet add src/QuranPlatform.API/QuranPlatform.API.csproj reference src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj

dotnet add tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj reference src/QuranPlatform.Domain/QuranPlatform.Domain.csproj
dotnet add tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj reference src/QuranPlatform.Application/QuranPlatform.Application.csproj

dotnet add tests/QuranPlatform.IntegrationTests/QuranPlatform.IntegrationTests.csproj reference src/QuranPlatform.API/QuranPlatform.API.csproj
```

---

## 🛠️ Step 2: Install NuGet Packages

Run these commands to add package dependencies:

```powershell
# Application Layer Packages
dotnet add src/QuranPlatform.Application/QuranPlatform.Application.csproj package MediatR
dotnet add src/QuranPlatform.Application/QuranPlatform.Application.csproj package FluentValidation
dotnet add src/QuranPlatform.Application/QuranPlatform.Application.csproj package FluentValidation.DependencyInjectionExtensions
dotnet add src/QuranPlatform.Application/QuranPlatform.Application.csproj package Microsoft.Extensions.Caching.Abstractions
dotnet add src/QuranPlatform.Application/QuranPlatform.Application.csproj package Microsoft.Extensions.Logging.Abstractions

# Infrastructure Layer Packages
dotnet add src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj package Npgsql.EntityFrameworkCore.PostgreSQL
dotnet add src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj package Pgvector.EntityFrameworkCore
dotnet add src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj package Microsoft.EntityFrameworkCore.Design
dotnet add src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj package Microsoft.Extensions.Caching.StackExchangeRedis
dotnet add src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj package OpenSearch.Client

# API Layer Packages
dotnet add src/QuranPlatform.API/QuranPlatform.API.csproj package Swashbuckle.AspNetCore
dotnet add src/QuranPlatform.API/QuranPlatform.API.csproj package Microsoft.AspNetCore.OpenApi

# Test Layer Packages
dotnet add tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj package Moq
dotnet add tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj package FluentAssertions
dotnet add tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj package NetArchTest.eShop

dotnet add tests/QuranPlatform.IntegrationTests/QuranPlatform.IntegrationTests.csproj package Microsoft.AspNetCore.Mvc.Testing
dotnet add tests/QuranPlatform.IntegrationTests/QuranPlatform.IntegrationTests.csproj package Testcontainers.PostgreSql
```

---

## 🛠️ Step 3: Implement Domain Layer (`src/QuranPlatform.Domain`)

Create the following files under `src/QuranPlatform.Domain/`:

### 1. `Entities/Surah.cs`

```csharp
namespace QuranPlatform.Domain.Entities;

public class Surah
{
    public int Id { get; set; }
    public int Number { get; set; }
    public string NameArabic { get; set; } = string.Empty;
    public string NamePersian { get; set; } = string.Empty;
    public string NameEnglish { get; set; } = string.Empty;
    public string RevelationType { get; set; } = string.Empty; // Makki or Madani
    public int VerseCount { get; set; }
}
```

### 2. `Entities/Verse.cs`

```csharp
namespace QuranPlatform.Domain.Entities;

public class Verse
{
    public int Id { get; set; }
    public int SurahId { get; set; }
    public int VerseNumber { get; set; }
    public int PageNumber { get; set; }
    public int JuzNumber { get; set; }
    public string TextUthmani { get; set; } = string.Empty;
    public string TextSimple { get; set; } = string.Empty;

    public Surah? Surah { get; set; }
    public ICollection<Translation> Translations { get; set; } = new List<Translation>();
}
```

### 3. `Entities/Translation.cs`

```csharp
namespace QuranPlatform.Domain.Entities;

public class Translation
{
    public int Id { get; set; }
    public int VerseId { get; set; }
    public string LanguageCode { get; set; } = "fa"; // 'fa' or 'en'
    public string AuthorName { get; set; } = string.Empty; // e.g. 'Makarem Shirazi' or 'Mustafa Khattab'
    public string TranslationText { get; set; } = string.Empty;

    public Verse? Verse { get; set; }
}
```

### 4. `ValueObjects/AyahKey.cs`

```csharp
namespace QuranPlatform.Domain.ValueObjects;

public readonly record struct AyahKey(int SurahId, int VerseNumber)
{
    public override string ToString() => $"{SurahId}:{VerseNumber}";

    public static AyahKey Parse(string key)
    {
        var parts = key.Split(':');
        if (parts.Length != 2 || !int.TryParse(parts[0], out var s) || !int.TryParse(parts[1], out var v))
        {
            throw new ArgumentException($"Invalid AyahKey format '{key}'. Expected format 'SurahId:VerseNumber' (e.g. 2:255).");
        }
        return new AyahKey(s, v);
    }
}
```

### 5. `Repositories/IQuranRepository.cs`

```csharp
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Domain.Repositories;

public interface IQuranRepository
{
    Task<Surah?> GetSurahByIdAsync(int surahId, CancellationToken ct = default);
    Task<Verse?> GetVerseByKeyAsync(AyahKey key, CancellationToken ct = default);
    Task<IEnumerable<Verse>> GetVersesBySurahIdAsync(int surahId, CancellationToken ct = default);
}
```

---

## 🛠️ Step 4: Implement Application Layer (`src/QuranPlatform.Application`)

### 1. `Common/Interfaces/ICultureContext.cs`

```csharp
namespace QuranPlatform.Application.Common.Interfaces;

public interface ICultureContext
{
    string CurrentCultureName { get; }
    bool IsPersian => CurrentCultureName.StartsWith("fa", StringComparison.OrdinalIgnoreCase);
}
```

### 2. `Behaviors/CultureContextBehavior.cs`

```csharp
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
```

### 3. `Queries/GetSurah/GetSurahByIdQuery.cs`

```csharp
using MediatR;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.Application.Queries.GetSurah;

public record SurahDto(int Id, int Number, string NameArabic, string LocalizedName, string RevelationType, int VerseCount);

public record GetSurahByIdQuery(int SurahId) : IRequest<SurahDto?>;

public class GetSurahByIdQueryHandler : IRequestHandler<GetSurahByIdQuery, SurahDto?>
{
    private readonly IQuranRepository _quranRepository;
    private readonly ICultureContext _cultureContext;

    public GetSurahByIdQueryHandler(IQuranRepository quranRepository, ICultureContext cultureContext)
    {
        _quranRepository = quranRepository;
        _cultureContext = cultureContext;
    }

    public async Task<SurahDto?> Handle(GetSurahByIdQuery request, CancellationToken cancellationToken)
    {
        var surah = await _quranRepository.GetSurahByIdAsync(request.SurahId, cancellationToken);
        if (surah == null) return null;

        var localizedName = _cultureContext.IsPersian ? surah.NamePersian : surah.NameEnglish;
        return new SurahDto(surah.Id, surah.Number, surah.NameArabic, localizedName, surah.RevelationType, surah.VerseCount);
    }
}
```

---

## 🛠️ Step 5: Implement Infrastructure Layer (`src/QuranPlatform.Infrastructure`)

### 1. `Persistence/QuranDbContext.cs`

```csharp
using Microsoft.EntityFrameworkCore;
using QuranPlatform.Domain.Entities;

namespace QuranPlatform.Infrastructure.Persistence;

public class QuranDbContext : DbContext
{
    public QuranDbContext(DbContextOptions<QuranDbContext> options) : base(options) { }

    public DbSet<Surah> Surahs => Set<Surah>();
    public DbSet<Verse> Verses => Set<Verse>();
    public DbSet<Translation> Translations => Set<Translation>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.HasPostgresExtension("vector");

        modelBuilder.Entity<Surah>(entity =>
        {
            entity.ToTable("Surah");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Number).IsUnique();
        });

        modelBuilder.Entity<Verse>(entity =>
        {
            entity.ToTable("Verse");
            entity.HasKey(e => e.Id);
            entity.HasOne(e => e.Surah).WithMany().HasForeignKey(e => e.SurahId);
        });

        modelBuilder.Entity<Translation>(entity =>
        {
            entity.ToTable("Translation");
            entity.HasKey(e => e.Id);
            entity.HasOne(e => e.Verse).WithMany(v => v.Translations).HasForeignKey(e => e.VerseId);
        });
    }
}
```

### 2. `Persistence/Repositories/QuranRepository.cs`

```csharp
using Microsoft.EntityFrameworkCore;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Infrastructure.Persistence.Repositories;

public class QuranRepository : IQuranRepository
{
    private readonly QuranDbContext _db;

    public QuranRepository(QuranDbContext db)
    {
        _db = db;
    }

    public async Task<Surah?> GetSurahByIdAsync(int surahId, CancellationToken ct = default)
    {
        return await _db.Surahs.FirstOrDefaultAsync(s => s.Id == surahId, ct);
    }

    public async Task<Verse?> GetVerseByKeyAsync(AyahKey key, CancellationToken ct = default)
    {
        return await _db.Verses
            .Include(v => v.Translations)
            .FirstOrDefaultAsync(v => v.SurahId == key.SurahId && v.VerseNumber == key.VerseNumber, ct);
    }

    public async Task<IEnumerable<Verse>> GetVersesBySurahIdAsync(int surahId, CancellationToken ct = default)
    {
        return await _db.Verses
            .Include(v => v.Translations)
            .Where(v => v.SurahId == surahId)
            .OrderBy(v => v.VerseNumber)
            .ToListAsync(ct);
    }
}
```

---

## 🛠️ Step 6: Implement Presentation API (`src/QuranPlatform.API`)

### 1. `Services/HttpContextCultureContext.cs`

```csharp
using System.Globalization;
using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.API.Services;

public class HttpContextCultureContext : ICultureContext
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public HttpContextCultureContext(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public string CurrentCultureName =>
        _httpContextAccessor.HttpContext?.Response.CultureInfo?.Name
        ?? CultureInfo.CurrentCulture.Name
        ?? "fa-IR";
}
```

### 2. `Controllers/QuranController.cs`

```csharp
using MediatR;
using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Queries.GetSurah;

namespace QuranPlatform.API.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class QuranController : ControllerBase
{
    private readonly IMediator _mediator;

    public QuranController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet("surah/{id:int}")]
    public async Task<IActionResult> GetSurah(int id, CancellationToken ct)
    {
        var result = await _mediator.Send(new GetSurahByIdQuery(id), ct);
        if (result == null) return NotFound(new { message = $"Surah with ID {id} not found." });
        return Ok(result);
    }
}
```

### 3. `Program.cs`

```csharp
using System.Globalization;
using MediatR;
using Microsoft.AspNetCore.Localization;
using Microsoft.EntityFrameworkCore;
using QuranPlatform.API.Services;
using QuranPlatform.Application.Behaviors;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Infrastructure.Persistence;
using QuranPlatform.Infrastructure.Persistence.Repositories;

var builder = WebApplication.CreateBuilder(args);

// 1. Configure Request Localization (fa-IR Default)
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

// 2. Add DbContext
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
    ?? "Host=localhost;Port=5432;Database=quran_db;Username=quran_admin;Password=quran_pass";

builder.Services.AddDbContext<QuranDbContext>(options =>
    options.UseNpgsql(connectionString, o => o.UseVector()));

// 3. Register Repositories & MediatR
builder.Services.AddScoped<IQuranRepository, QuranRepository>();
builder.Services.AddMediatR(cfg =>
{
    cfg.RegisterServicesFromAssembly(typeof(ICultureContext).Assembly);
    cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(CultureContextBehavior<,>));
});

// 4. Redis Cache / In-Memory Fallback
var redisConn = builder.Configuration.GetConnectionString("Redis");
if (!string.IsNullOrEmpty(redisConn))
{
    builder.Services.AddStackExchangeRedisCache(options => options.Configuration = redisConn);
}
else
{
    builder.Services.AddDistributedMemoryCache(); // Automatic fallback for Windows / local dev
}

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Enable Localization Middleware FIRST
app.UseRequestLocalization();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();
app.MapControllers();

app.Run();
```

---

## 🛠️ Step 7: NetArchTest Architecture Test (`tests/QuranPlatform.UnitTests`)

### `ArchitectureTests/CleanArchitectureTests.cs`

```csharp
using FluentAssertions;
using NetArchTest.Rules;
using Xunit;

namespace QuranPlatform.UnitTests.ArchitectureTests;

public class CleanArchitectureTests
{
    [Fact]
    public void DomainLayer_Should_Not_HaveDependencyOn_OtherProjects()
    {
        var result = Types.InAssembly(typeof(Domain.Entities.Surah).Assembly)
            .ShouldNot()
            .HaveDependencyOnAll("QuranPlatform.Application", "QuranPlatform.Infrastructure", "QuranPlatform.API")
            .GetResult();

        result.IsSuccessful.Should().BeTrue();
    }
}
```

---

## 🚀 Step 8: Build, Test & Run

Run these commands to test and start the server:

```powershell
# 1. Build Solution
dotnet build

# 2. Run Unit & Architecture Tests
dotnet test tests/QuranPlatform.UnitTests/QuranPlatform.UnitTests.csproj

# 3. Launch Web API Server
dotnet run --project src/QuranPlatform.API/QuranPlatform.API.csproj
```
