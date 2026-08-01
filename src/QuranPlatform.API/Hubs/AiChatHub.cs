using Microsoft.AspNetCore.SignalR;
using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.API.Hubs;

public class AiChatHub : Hub
{
    private readonly IRagEngine _ragEngine;
    private readonly ICultureContext _cultureContext;

    public AiChatHub(IRagEngine ragEngine, ICultureContext cultureContext)
    {
        _ragEngine = ragEngine;
        _cultureContext = cultureContext;
    }

    public async Task SendMessage(string userQuestion)
    {
        var cultureCode = _cultureContext.CurrentCultureName;

        await foreach (var token in _ragEngine.StreamAnswerAsync(userQuestion, cultureCode, Context.ConnectionAborted))
        {
            await Clients.Caller.SendAsync("ReceiveToken", token);
        }

        await Clients.Caller.SendAsync("StreamComplete");
    }
}
