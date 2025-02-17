using Evently.Modules.Event.Api.Database;
using Evently.Modules.Event.Api.Events;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Evently.Modules.Event.Api;

/// <summary>
/// Composition root for the Events module.
/// Responsible for configuring dependency injection, registering services, and mapping endpoints.
/// </summary>
public static class EventsModule
{
    public static void MapEndpoints(IEndpointRouteBuilder app)
    {
        GetEvent.MapEndpoint(app);
        CreateEvent.MapEndpoint(app);
    }

    public static IServiceCollection AddEventsModule(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        string databaseConnectionString = configuration.GetConnectionString("EventsDatabase")!;
        services.AddDbContext<EventsDbContext>(options =>
        {
            options.UseNpgsql(
                databaseConnectionString, 
                npgsqlOptions => npgsqlOptions
                    .MigrationsHistoryTable(HistoryRepository.DefaultTableName, Schemas.Events))
            .UseSnakeCaseNamingConvention();
        });

        return services;
    }
}
