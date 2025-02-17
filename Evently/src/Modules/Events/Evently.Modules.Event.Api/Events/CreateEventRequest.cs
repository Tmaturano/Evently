namespace Evently.Modules.Event.Api.Events;

public static partial class CreateEvent
{
    internal sealed record CreateEventRequest(
        string Title, 
        string Description, 
        string Location, 
        DateTime StartsAtUtc, 
        DateTime? EndsAtUtc);
}
