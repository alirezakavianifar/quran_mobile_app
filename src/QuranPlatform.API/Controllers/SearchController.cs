using MediatR;
using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Queries.Search;

namespace QuranPlatform.API.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class SearchController : ControllerBase
{
    private readonly IMediator _mediator;

    public SearchController(IMediator mediator)
    {
        _mediator = mediator;
    }

    /// <summary>
    /// Multilingual Hybrid Search (OpenSearch BM25 + pgvector + Reciprocal Rank Fusion).
    /// Defaults to Persian (fa-IR) with Makarem Shirazi translation unless Accept-Language: en-US is specified.
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> Search([FromQuery] string q, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(q))
        {
            return BadRequest(new { message = "Search query string 'q' cannot be empty." });
        }

        var result = await _mediator.Send(new SearchVersesQuery(q, page, pageSize), ct);
        return Ok(result);
    }
}
