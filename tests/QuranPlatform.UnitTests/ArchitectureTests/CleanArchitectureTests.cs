using FluentAssertions;
using NetArchTest.Rules;
using Xunit;

namespace QuranPlatform.UnitTests.ArchitectureTests;

public class CleanArchitectureTests
{
    [Fact]
    public void DomainLayer_Should_Not_HaveDependencyOn_OtherProjects()
    {
        var result = Types.InAssembly(typeof(QuranPlatform.Domain.Entities.Surah).Assembly)
            .ShouldNot()
            .HaveDependencyOnAll("QuranPlatform.Application", "QuranPlatform.Infrastructure", "QuranPlatform.API")
            .GetResult();

        result.IsSuccessful.Should().BeTrue();
    }

    [Fact]
    public void ApplicationLayer_Should_Not_HaveDependencyOn_InfrastructureOrAPI()
    {
        var result = Types.InAssembly(typeof(QuranPlatform.Application.Common.Interfaces.ICultureContext).Assembly)
            .ShouldNot()
            .HaveDependencyOnAll("QuranPlatform.Infrastructure", "QuranPlatform.API")
            .GetResult();

        result.IsSuccessful.Should().BeTrue();
    }
}
