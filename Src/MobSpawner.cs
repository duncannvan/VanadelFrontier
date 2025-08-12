using Godot;
using System;
using System.Collections.Generic;

public sealed partial class MobSpawner : Node2D
{
	[Signal]
	public delegate void WaveClearedEventHandler();

	private Queue<PackedScene> _mobQueue = new Queue<PackedScene>();

	[Export]
	private Base _base = null;

	public async void StartWave(WaveData wave)
	{
		_mobQueue = new Queue<PackedScene>(wave.Mobs);
		while (_mobQueue.Count > 0)
		{
			Mob mobInstance = _mobQueue.Dequeue().Instantiate<Mob>();
			mobInstance.GlobalPosition = GlobalPosition;
			mobInstance.Init(_base);
			mobInstance.MobDied += OnMobDied;
			GetTree().Root.AddChild(mobInstance);

			await ToSignal(GetTree().CreateTimer(wave.SpawnInterval), "timeout");
		}
	}

	private void OnMobDied()
	{
		//TODO: Why 1 mob in scene check
		// The ordering is OnMobDied()-> mob.QueueFree(), meaning 1 mob in group at function call == wave cleared
		if (GetTree().GetNodesInGroup("mobs").Count == 1 && _mobQueue.Count == 0)
		{
			EmitSignal(nameof(WaveCleared));
		}
	}
}
