
using Godot;

[GlobalClass]
public sealed partial class MobSpawnData : Resource
{
    public enum TargetType : byte
    {
        BASE,
        PLAYER,
        TOWER
    }

    [Export]
    public PackedScene MobScene { get; private set; }

    [Export]
    public byte Count { get; private set; }

    [Export]
    public float DelaySpawnSec { get; private set; }

    [Export]
    public TargetType Target { get; private set; }
}
