using Godot;
using System;

[GlobalClass]
public sealed partial class WaveData : Resource
{
    [Export]
    public float SpawnInterval { get; private set; } = 1.0f;

    [Export]
    public PackedScene[] Mobs { get; private set; } = Array.Empty<PackedScene>();
}
