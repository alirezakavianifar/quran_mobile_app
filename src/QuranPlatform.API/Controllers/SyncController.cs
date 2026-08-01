using MediatR;
using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Sync.Commands;
using QuranPlatform.Application.Sync.DTOs;
using QuranPlatform.Application.Sync.Queries;

namespace QuranPlatform.API.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class SyncController : ControllerBase
{
    private readonly ISender _mediator;

    public SyncController(ISender mediator)
    {
        _mediator = mediator;
    }

    /// <summary>
    /// Synchronizes user bookmarks, highlights, notes, and reading history with the cloud repository.
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<SyncResultDto>> SyncUserData([FromBody] SyncPayloadDto payload, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(payload.UserId))
        {
            return BadRequest(new { Message = "UserId is required for synchronization." });
        }

        var result = await _mediator.Send(new SyncUserDataCommand(payload), ct);
        return Ok(result);
    }

    /// <summary>
    /// Retrieves the current synchronized remote user data for a specific user ID.
    /// </summary>
    [HttpGet("{userId}")]
    public async Task<ActionResult<SyncPayloadDto>> GetUserData(string userId, CancellationToken ct)
    {
        var result = await _mediator.Send(new GetUserDataQuery(userId), ct);
        if (result == null)
        {
            return NotFound(new { Message = $"No synced data found for user '{userId}'." });
        }

        return Ok(result);
    }
}
