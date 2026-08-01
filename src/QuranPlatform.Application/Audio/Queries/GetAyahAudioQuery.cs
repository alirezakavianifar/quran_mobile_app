using MediatR;
using QuranPlatform.Application.Audio.DTOs;

namespace QuranPlatform.Application.Audio.Queries;

public record GetAyahAudioQuery(string ReciterId, int SurahId, int VerseNumber) : IRequest<AyahAudioDto?>;

public class GetAyahAudioQueryHandler : IRequestHandler<GetAyahAudioQuery, AyahAudioDto?>
{
    private static readonly Dictionary<string, string> ReciterBaseUrls = new()
    {
        { "alafasy", "https://everyayah.com/data/Alafasy_128kbps/" },
        { "husary", "https://everyayah.com/data/Husary_128kbps/" },
        { "abdulbasit", "https://everyayah.com/data/Abdul_Basit_Mujawwad_128kbps/" },
        { "parhizgar", "https://everyayah.com/data/Parhizgar_48kbps/" }
    };

    public Task<AyahAudioDto?> Handle(GetAyahAudioQuery request, CancellationToken cancellationToken)
    {
        var reciterId = request.ReciterId.ToLowerInvariant();
        if (!ReciterBaseUrls.TryGetValue(reciterId, out var baseUrl))
        {
            reciterId = "alafasy";
            baseUrl = ReciterBaseUrls["alafasy"];
        }

        // Format surah and verse numbers as 3 digits (e.g. 001001.mp3)
        var fileName = $"{request.SurahId:D3}{request.VerseNumber:D3}.mp3";
        var audioUrl = $"{baseUrl}{fileName}";

        var dto = new AyahAudioDto(
            ReciterId: reciterId,
            SurahId: request.SurahId,
            VerseNumber: request.VerseNumber,
            AudioUrl: audioUrl,
            DurationMs: 6000,
            WordTimings: new List<AyahAudioTimingDto>
            {
                new AyahAudioTimingDto(0, 0, 1500),
                new AyahAudioTimingDto(1, 1500, 3500),
                new AyahAudioTimingDto(2, 3500, 6000)
            }
        );

        return Task.FromResult<AyahAudioDto?>(dto);
    }
}
