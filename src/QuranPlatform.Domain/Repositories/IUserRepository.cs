using QuranPlatform.Domain.Entities;

namespace QuranPlatform.Domain.Repositories;

public interface IUserRepository
{
    Task<User?> GetUserByIdAsync(Guid userId, CancellationToken ct = default);
    Task<UserSettings?> GetUserSettingsAsync(Guid userId, CancellationToken ct = default);
    Task SaveUserSettingsAsync(UserSettings settings, CancellationToken ct = default);
}
