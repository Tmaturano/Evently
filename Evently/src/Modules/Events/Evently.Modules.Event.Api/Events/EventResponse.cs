using Evently.Modules.Event.Api.Enums;

namespace Evently.Modules.Event.Api.Events;

public sealed record EventResponse(
    Guid Id, 
    string Title, 
    string Description, 
    string Location, 
    DateTime StartsAtUtc, 
    DateTime? EndsAtUtc, 
    EventStatus Status);
