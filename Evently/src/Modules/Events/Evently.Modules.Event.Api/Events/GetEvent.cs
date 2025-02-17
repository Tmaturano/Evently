using Evently.Modules.Event.Api.Database;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;

namespace Evently.Modules.Event.Api.Events;
public static class GetEvent
{
    public static void MapEndpoint(IEndpointRouteBuilder app)
    {
        app.MapGet("/events/{eventId}", async (Guid eventId, EventsDbContext dbContext) =>
        {
            EventResponse? @event = await dbContext.Events
                .Where(e => e.Id == eventId)
                .Select(e => new EventResponse(
                    e.Id, 
                    e.Title, 
                    e.Description, 
                    e.Location, 
                    e.StartsAtUtc, 
                    e.EndsAtUtc, 
                    e.Status))
                .FirstOrDefaultAsync();

            return @event is null ? Results.NotFound() : Results.Ok(@event);
        }).WithTags(Tags.Events);
    }
}
