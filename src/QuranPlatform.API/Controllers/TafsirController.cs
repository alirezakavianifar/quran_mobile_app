using MediatR;
using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Queries.GetTafsir;

namespace QuranPlatform.API.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class TafsirController : ControllerBase
{
    private readonly IMediator _mediator;

    public TafsirController(IMediator mediator)
    {
        _mediator = mediator;
    }

    /// <summary>
    /// Gets Tafsir commentary for a verse by key and edition ID.
    /// </summary>
    [HttpGet("{key}/{editionId:int}")]
    public async Task<IActionResult> GetTafsir(string key, int editionId, CancellationToken ct)
    {
        var result = await _mediator.Send(new GetTafsirForVerseQuery(key, editionId), ct);
        if (result == null)
        {
            return NotFound(new { message = $"Tafsir for verse '{key}' edition {editionId} not found." });
        }
        return Ok(result);
    }
}
