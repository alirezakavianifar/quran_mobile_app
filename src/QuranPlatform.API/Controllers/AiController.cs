using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.API.Controllers;

public record AiAskRequest(string Question);

[ApiController]
[Route("api/v1/[controller]")]
public class AiController : ControllerBase
{
    private readonly IRagEngine _ragEngine;
    private readonly ICultureContext _cultureContext;

    public AiController(IRagEngine ragEngine, ICultureContext cultureContext)
    {
        _ragEngine = ragEngine;
        _cultureContext = cultureContext;
    }

    /// <summary>
    /// Generates grounded AI responses based on Quran text and Tafsir Nemoneh / Ibn Kathir.
    /// </summary>
    [HttpPost("ask")]
    public async Task<IActionResult> Ask([FromBody] AiAskRequest request, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(request.Question))
        {
            return BadRequest(new { message = "Question parameter cannot be empty." });
        }

        var cultureCode = _cultureContext.CurrentCultureName;
        var answer = await _ragEngine.AnswerQuestionAsync(request.Question, cultureCode, ct);

        return Ok(answer);
    }
}
