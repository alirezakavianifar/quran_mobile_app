using Microsoft.AspNetCore.SignalR;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.ValueObjects;
using QuranPlatform.Infrastructure.AI;

namespace QuranPlatform.API.Hubs;

public class AiChatHub : Hub
{
    private readonly ILLMProvider _llmProvider;
    private readonly ICultureContext _cultureContext;

    public AiChatHub(ILLMProvider llmProvider, ICultureContext cultureContext)
    {
        _llmProvider = llmProvider;
        _cultureContext = cultureContext;
    }

    public async Task SendMessage(string userQuestion)
    {
        var culture = new PreferredCulture(_cultureContext.CurrentCultureName);
        var fullAnswer = await _llmProvider.GenerateGroundedAnswerAsync(userQuestion, culture, Context.ConnectionAborted);

        // Stream answer token-by-token
        var tokens = fullAnswer.Split(' ');
        foreach (var token in tokens)
        {
            await Clients.Caller.SendAsync("ReceiveToken", token + " ");
            await Task.Delay(50);
        }

        await Clients.Caller.SendAsync("StreamComplete");
    }
}
