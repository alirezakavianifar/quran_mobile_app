using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.ValueObjects;
using QuranPlatform.Infrastructure.AI;

namespace QuranPlatform.API.Controllers;

public record AiAskRequest(string Question);

[ApiController]
[Route("api/v1/[controller]")]
public class AiController : ControllerBase
{
    private readonly ILLMProvider _llmProvider;
    private readonly ICultureContext _cultureContext;

    public AiController(ILLMProvider llmProvider, ICultureContext cultureContext)
    {
        _llmProvider = llmProvider;
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

        var culture = new PreferredCulture(_cultureContext.CurrentCultureName);
        var answer = await _llmProvider.GenerateGroundedAnswerAsync(request.Question, culture, ct);

        return Ok(new
        {
            Question = request.Question,
            Answer = answer,
            Culture = culture.CultureCode,
            TextDirection = culture.TextDirection
        });
    }
}
