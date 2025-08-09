using Godot;

[GlobalClass]
public sealed partial class StatsSheet : Resource
{
    [Export]
    public int Health { get; set; } = 3;

    [Export]
    public int Speed { get; private set; } = 20;
}