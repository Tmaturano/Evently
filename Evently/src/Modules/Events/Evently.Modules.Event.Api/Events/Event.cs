using Evently.Modules.Event.Api.Enums;

namespace Evently.Modules.Event.Api.Events;

public sealed class Event
{
    public Guid Id { get; set; }

    public string Title { get; set; }

    public string Description { get; set; }

    public string Location { get; set; }

    public DateTime StartsAtUtc { get; set; }

    public DateTime? EndsAtUtc { get; set; }

    public EventStatus Status { get; set; }
}
