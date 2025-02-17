using Microsoft.EntityFrameworkCore;

namespace Evently.Modules.Event.Api.Database;
public sealed class EventsDbContext(DbContextOptions<EventsDbContext> options) : DbContext(options)
{
    internal DbSet<Events.Event> Events { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(Schemas.Events);        
    }
}
