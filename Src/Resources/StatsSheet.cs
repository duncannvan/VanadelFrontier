using Godot;

[GlobalClass]
public sealed partial class StatsSheet : Resource
{
    [Export]
    public byte Health { get; set; } = 3;

    [Export]
    public byte Speed { get; private set; } = 20;
}