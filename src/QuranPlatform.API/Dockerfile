# Stage 1: Build & Publish
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy solution and project files
COPY ["src/QuranPlatform.API/QuranPlatform.API.csproj", "src/QuranPlatform.API/"]
COPY ["src/QuranPlatform.Application/QuranPlatform.Application.csproj", "src/QuranPlatform.Application/"]
COPY ["src/QuranPlatform.Domain/QuranPlatform.Domain.csproj", "src/QuranPlatform.Domain/"]
COPY ["src/QuranPlatform.Infrastructure/QuranPlatform.Infrastructure.csproj", "src/QuranPlatform.Infrastructure/"]

# Restore dependencies
RUN dotnet restore "src/QuranPlatform.API/QuranPlatform.API.csproj"

# Copy full source
COPY src/ src/

# Build and publish
WORKDIR "/src/src/QuranPlatform.API"
RUN dotnet publish "QuranPlatform.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime Container
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_URLS=http://+:80
ENV ASPNETCORE_ENVIRONMENT=Production

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "QuranPlatform.API.dll"]
