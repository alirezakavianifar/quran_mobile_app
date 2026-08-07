using FluentAssertions;
using Moq;
using QuranPlatform.Application.AI;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.ValueObjects;
using Xunit;

namespace QuranPlatform.UnitTests.AITests;

public class RagEngineTests
{
    [Theory]
    [InlineData("fa-IR", RagPromptBuilder.PersianSystemPrompt)]
    [InlineData("en-US", RagPromptBuilder.EnglishSystemPrompt)]
    public void GetSystemInstruction_ShouldReturnCorrectLanguagePrompt(string cultureCode, string expectedInstruction)
    {
        var instruction = RagPromptBuilder.GetSystemInstruction(cultureCode);

        instruction.Instructions.Should().Be(expectedInstruction);
        instruction.CultureCode.Should().Be(cultureCode);
    }

    [Fact]
    public void BuildPromptWithContext_ShouldFormatPersianSourcesCorrectly()
    {
        var verse = new Verse { SurahId = 2, VerseNumber = 255, TextUthmani = "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ" };
        var tafsir = new Tafsir { TafsirEditionId = 1, ContentText = "الله معبودی جز او نیست..." };

        var items = new List<(Verse Verse, Translation? Translation, Tafsir? Tafsir)>
        {
            (verse, null, tafsir)
        };

        var formattedPrompt = RagPromptBuilder.BuildPromptWithContext("معنی آیت الکرسی چیست؟", items, "fa-IR");

        formattedPrompt.Should().Contain("### منابع مستخرج قرآن و تفسیر:");
        formattedPrompt.Should().Contain("Surah 2, Ayah 255:");
        formattedPrompt.Should().Contain("Tafsir (Edition #1):");
        formattedPrompt.Should().Contain("سوال کاربر: معنی آیت الکرسی چیست؟");
    }

    [Fact]
    public async Task AnswerQuestionAsync_WhenNoMatchingVersesFound_ShouldReturnInsufficientContextGuardrail()
    {
        var embeddingMock = new Mock<IEmbeddingService>();
        var vectorSearchMock = new Mock<IVectorSearchService>();
        var quranRepoMock = new Mock<IQuranRepository>();
        var tafsirRepoMock = new Mock<ITafsirRepository>();
        var llmProviderMock = new Mock<ILLMProvider>();

        vectorSearchMock
            .Setup(v => v.SearchVectorAsync(It.IsAny<string>(), It.IsAny<PreferredCulture>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(Enumerable.Empty<AyahKey>());

        var ragEngine = new RagEngine(
            embeddingMock.Object,
            vectorSearchMock.Object,
            quranRepoMock.Object,
            tafsirRepoMock.Object,
            llmProviderMock.Object);

        var answer = await ragEngine.AnswerQuestionAsync("سوال نامربوط", "fa-IR");

        answer.HasSufficientContext.Should().BeFalse();
        answer.AnswerText.Should().Be(RagPromptBuilder.PersianInsufficientContextMessage);
        answer.Citations.Should().BeEmpty();
    }

    [Fact]
    public async Task AnswerQuestionAsync_WhenVersesRetrieved_ShouldInvokeLLMAndReturnCitations()
    {
        var embeddingMock = new Mock<IEmbeddingService>();
        var vectorSearchMock = new Mock<IVectorSearchService>();
        var quranRepoMock = new Mock<IQuranRepository>();
        var tafsirRepoMock = new Mock<ITafsirRepository>();
        var llmProviderMock = new Mock<ILLMProvider>();

        var ayahKey = new AyahKey(1, 1);
        vectorSearchMock
            .Setup(v => v.SearchVectorAsync(It.IsAny<string>(), It.IsAny<PreferredCulture>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new[] { ayahKey });

        quranRepoMock
            .Setup(q => q.GetVerseByKeyAsync(ayahKey, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new Verse { SurahId = 1, VerseNumber = 1, TextUthmani = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ" });

        tafsirRepoMock
            .Setup(t => t.GetTafsirForVerseAsync(ayahKey, 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new Tafsir { TafsirEditionId = 1, ContentText = "بنام خداوند بخشنده مهربان" });

        llmProviderMock
            .Setup(l => l.GenerateGroundedAnswerAsync(It.IsAny<string>(), It.IsAny<SystemInstruction>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync("پاسخ مستند به تفسیر نمونه [سوره 1:1]");

        var ragEngine = new RagEngine(
            embeddingMock.Object,
            vectorSearchMock.Object,
            quranRepoMock.Object,
            tafsirRepoMock.Object,
            llmProviderMock.Object);

        var answer = await ragEngine.AnswerQuestionAsync("بسم الله یعنی چه؟", "fa-IR");

        answer.HasSufficientContext.Should().BeTrue();
        answer.AnswerText.Should().Contain("پاسخ مستند");
        answer.Citations.Should().HaveCount(1);
        answer.Citations[0].SurahId.Should().Be(1);
    }

    [Fact]
    public async Task AnswerQuestionAsync_WhenSurah20Query_ShouldHydrateSurah20ContextDirectly()
    {
        var embeddingMock = new Mock<IEmbeddingService>();
        var vectorSearchMock = new Mock<IVectorSearchService>();
        var quranRepoMock = new Mock<IQuranRepository>();
        var tafsirRepoMock = new Mock<ITafsirRepository>();
        var llmProviderMock = new Mock<ILLMProvider>();

        var surah20Key = new AyahKey(20, 1);
        quranRepoMock
            .Setup(q => q.GetVerseByKeyAsync(surah20Key, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new Verse { SurahId = 20, VerseNumber = 1, TextUthmani = "طه" });

        tafsirRepoMock
            .Setup(t => t.GetTafsirForVerseAsync(surah20Key, 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new Tafsir { TafsirEditionId = 1, ContentText = "تفسیر سوره طه" });

        llmProviderMock
            .Setup(l => l.GenerateGroundedAnswerAsync(It.IsAny<string>(), It.IsAny<SystemInstruction>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync("سوره مبارکه طه بیستمین سوره قرآن [سوره 20:1]");

        var ragEngine = new RagEngine(
            embeddingMock.Object,
            vectorSearchMock.Object,
            quranRepoMock.Object,
            tafsirRepoMock.Object,
            llmProviderMock.Object);

        var answer = await ragEngine.AnswerQuestionAsync("سوره بیستم قرآن", "fa-IR");

        answer.HasSufficientContext.Should().BeTrue();
        answer.AnswerText.Should().Contain("سوره مبارکه طه");
        answer.Citations.Should().NotBeEmpty();
        answer.Citations[0].SurahId.Should().Be(20);
    }
}
