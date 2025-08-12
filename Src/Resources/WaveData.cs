using Godot;
using System;

public sealed partial class WaveData : Resource
{
    [Export]
    public float SpawnInterval { get; private set; } = 1.0f;

    [Export]
    public PackedScene[] Mobs { get; private set; } = Array.Empty<PackedScene>();
}
