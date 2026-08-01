using Microsoft.EntityFrameworkCore;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.Infrastructure.Persistence.Repositories;

public class UserRepository : IUserRepository
{
    private readonly QuranDbContext _db;

    public UserRepository(QuranDbContext db)
    {
        _db = db;
    }

    public async Task<User?> GetUserByIdAsync(Guid userId, CancellationToken ct = default)
    {
        return await _db.Users
            .AsNoTracking()
            .Include(u => u.Settings)
            .FirstOrDefaultAsync(u => u.Id == userId, ct);
    }

    public async Task<UserSettings?> GetUserSettingsAsync(Guid userId, CancellationToken ct = default)
    {
        return await _db.UserSettings
            .AsNoTracking()
            .FirstOrDefaultAsync(us => us.UserId == userId, ct);
    }

    public async Task SaveUserSettingsAsync(UserSettings settings, CancellationToken ct = default)
    {
        var existing = await _db.UserSettings.FirstOrDefaultAsync(us => us.UserId == settings.UserId, ct);
        if (existing == null)
        {
            _db.UserSettings.Add(settings);
        }
        else
        {
            _db.Entry(existing).CurrentValues.SetValues(settings);
        }
        await _db.SaveChangesAsync(ct);
    }
}
