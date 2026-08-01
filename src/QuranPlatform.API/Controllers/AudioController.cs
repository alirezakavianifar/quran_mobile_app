using MediatR;
using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Audio.DTOs;
using QuranPlatform.Application.Audio.Queries;

namespace QuranPlatform.API.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class AudioController : ControllerBase
{
    private readonly ISender _mediator;

    public AudioController(ISender mediator)
    {
        _mediator = mediator;
    }

    /// <summary>
    /// Returns the list of available Quran reciters and audio stream metadata.
    /// </summary>
    [HttpGet("reciters")]
    public async Task<ActionResult<IEnumerable<ReciterDto>>> GetReciters(CancellationToken ct)
    {
        var result = await _mediator.Send(new GetRecitersQuery(), ct);
        return Ok(result);
    }

    /// <summary>
    /// Returns the audio stream URL and word-by-word timing metadata for a specific verse and reciter.
    /// </summary>
    [HttpGet("ayah/{reciterId}/{surahId:int}/{verseId:int}")]
    public async Task<ActionResult<AyahAudioDto>> GetAyahAudio(string reciterId, int surahId, int verseId, CancellationToken ct)
    {
        var result = await _mediator.Send(new GetAyahAudioQuery(reciterId, surahId, verseId), ct);
        if (result == null)
        {
            return NotFound(new { Message = $"Audio not found for reciter '{reciterId}', surah {surahId}, verse {verseId}." });
        }

        return Ok(result);
    }
}
