using Microsoft.EntityFrameworkCore;
using QuranPlatform.Domain.Entities;

namespace QuranPlatform.Infrastructure.Persistence;

public class QuranDbContext : DbContext
{
    public QuranDbContext(DbContextOptions<QuranDbContext> options) : base(options) { }

    public DbSet<Surah> Surahs => Set<Surah>();
    public DbSet<Verse> Verses => Set<Verse>();
    public DbSet<Translation> Translations => Set<Translation>();
    public DbSet<Tafsir> Tafsirs => Set<Tafsir>();
    public DbSet<User> Users => Set<User>();
    public DbSet<UserSettings> UserSettings => Set<UserSettings>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Enable pgvector PostgreSQL extension
        modelBuilder.HasPostgresExtension("vector");

        modelBuilder.Entity<Surah>(entity =>
        {
            entity.ToTable("Surah");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Number).IsUnique();
            entity.Property(e => e.NameArabic).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NamePersian).IsRequired().HasMaxLength(100);
            entity.Property(e => e.NameEnglish).IsRequired().HasMaxLength(100);
        });

        modelBuilder.Entity<Verse>(entity =>
        {
            entity.ToTable("Verse");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.SurahId, e.VerseNumber }).IsUnique();
            entity.HasOne(e => e.Surah).WithMany().HasForeignKey(e => e.SurahId).OnDelete(DeleteBehavior.Cascade);
            entity.Property(e => e.TextUthmani).IsRequired();
            entity.Property(e => e.TextSimple).IsRequired();
        });

        modelBuilder.Entity<Translation>(entity =>
        {
            entity.ToTable("Translation");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.VerseId, e.LanguageCode, e.AuthorName });
            entity.HasOne(e => e.Verse).WithMany(v => v.Translations).HasForeignKey(e => e.VerseId).OnDelete(DeleteBehavior.Cascade);
            entity.Property(e => e.LanguageCode).IsRequired().HasMaxLength(10);
            entity.Property(e => e.TranslationText).IsRequired();
        });

        modelBuilder.Entity<Tafsir>(entity =>
        {
            entity.ToTable("TafsirContent");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.VerseId, e.TafsirEditionId });
            entity.HasOne(e => e.Verse).WithMany(v => v.Tafsirs).HasForeignKey(e => e.VerseId).OnDelete(DeleteBehavior.Cascade);
            entity.Property(e => e.ContentText).IsRequired();
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("Users");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Email).IsUnique();
            entity.Property(e => e.Email).IsRequired().HasMaxLength(255);
        });

        modelBuilder.Entity<UserSettings>(entity =>
        {
            entity.ToTable("UserSettings");
            entity.HasKey(e => e.UserId);
            entity.HasOne(e => e.User).WithOne(u => u.Settings).HasForeignKey<UserSettings>(e => e.UserId).OnDelete(DeleteBehavior.Cascade);
            entity.Property(e => e.PreferredLanguage).HasMaxLength(10).HasDefaultValue("fa");
            entity.Property(e => e.SecondaryLanguage).HasMaxLength(10).HasDefaultValue("en");
            entity.Property(e => e.TextDirection).HasMaxLength(5).HasDefaultValue("rtl");
            entity.Property(e => e.FontFamily).HasMaxLength(100).HasDefaultValue("Vazirmatn");
        });
    }
}
