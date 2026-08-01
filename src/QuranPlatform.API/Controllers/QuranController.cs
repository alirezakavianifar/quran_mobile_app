using MediatR;
using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Queries.GetSurah;
using QuranPlatform.Application.Queries.GetVerse;

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

    /// <summary>
    /// Gets Surah metadata by ID (localized by Accept-Language header, fa-IR default).
    /// </summary>
    [HttpGet("surah/{id:int}")]
    public async Task<IActionResult> GetSurah(int id, CancellationToken ct)
    {
        var result = await _mediator.Send(new GetSurahByIdQuery(id), ct);
        if (result == null)
        {
            return NotFound(new { message = $"Surah with ID {id} not found." });
        }
        return Ok(result);
    }

    /// <summary>
    /// Gets all 114 Surahs with localized names.
    /// </summary>
    [HttpGet("surahs")]
    public async Task<IActionResult> GetAllSurahs(CancellationToken ct)
    {
        var result = await _mediator.Send(new GetAllSurahsQuery(), ct);
        return Ok(result);
    }

    /// <summary>
    /// Gets Verse text and translation by AyahKey (e.g. "2:255").
    /// </summary>
    [HttpGet("verse/{key}")]
    public async Task<IActionResult> GetVerse(string key, CancellationToken ct)
    {
        var result = await _mediator.Send(new GetVerseByKeyQuery(key), ct);
        if (result == null)
        {
            return NotFound(new { message = $"Verse with key '{key}' not found." });
        }
        return Ok(result);
    }
}
