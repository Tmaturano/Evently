using Evently.Modules.Event.Api.Database;
using Evently.Modules.Event.Api.Enums;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;

namespace Evently.Modules.Event.Api.Events;

public static partial class CreateEvent
{
    public static void MapEndpoint(IEndpointRouteBuilder app)
    {
        app.MapPost("/events", async (CreateEventRequest request, EventsDbContext dbContext) =>
        {
            var @event = new Event
            {
                Id = Guid.NewGuid(),
                Title = request.Title,
                Description = request.Description,
                Location = request.Location,
                StartsAtUtc = request.StartsAtUtc,
                EndsAtUtc = request.EndsAtUtc,
                Status = EventStatus.Draft
            };

            dbContext.Events.Add(@event);
            await dbContext.SaveChangesAsync();

            return Results.Ok(@event.Id);
        }).WithTags(Tags.Events);
    }
}
