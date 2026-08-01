using MediatR;
using QuranPlatform.Application.Audio.DTOs;

namespace QuranPlatform.Application.Audio.Queries;

public record GetRecitersQuery : IRequest<List<ReciterDto>>;

public class GetRecitersQueryHandler : IRequestHandler<GetRecitersQuery, List<ReciterDto>>
{
    private static readonly List<ReciterDto> Reciters = new()
    {
        new ReciterDto(
            Id: "alafasy",
            NameArabic: "مشاري راشد العفاسي",
            NamePersian: "مشاری راشد العفاسی",
            NameEnglish: "Mishary Rashid Alafasy",
            Style: "Murattal",
            BaseUrl: "https://everyayah.com/data/Alafasy_128kbps/"
        ),
        new ReciterDto(
            Id: "husary",
            NameArabic: "محمود خليل الحصري",
            NamePersian: "محمود خلیل الحصری",
            NameEnglish: "Mahmoud Khalil Al-Husary",
            Style: "Murattal",
            BaseUrl: "https://everyayah.com/data/Husary_128kbps/"
        ),
        new ReciterDto(
            Id: "abdulbasit",
            NameArabic: "عبد الباسط عبد الصمد",
            NamePersian: "عبدالباسط عبدالصمد",
            NameEnglish: "Abdul Basit Abdul Samad",
            Style: "Mujawwad",
            BaseUrl: "https://everyayah.com/data/Abdul_Basit_Mujawwad_128kbps/"
        ),
        new ReciterDto(
            Id: "parhizgar",
            NameArabic: "شهريار پرهيزكار",
            NamePersian: "شهریار پرهیزگار",
            NameEnglish: "Shahriar Parhizgar",
            Style: "Tartil",
            BaseUrl: "https://everyayah.com/data/Parhizgar_48kbps/",
            BitrateKbps: 48
        )
    };

    public Task<List<ReciterDto>> Handle(GetRecitersQuery request, CancellationToken cancellationToken)
    {
        return Task.FromResult(Reciters);
    }
}
