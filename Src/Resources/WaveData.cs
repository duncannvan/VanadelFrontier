using Godot;

[GlobalClass]
public sealed partial class WaveData : Resource
{
    [Export]
    public MobSpawnData[] MobWaveData { get; private set; }
}
