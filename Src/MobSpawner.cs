using Godot;
using System.Collections.Generic;

[GlobalClass]
public sealed partial class MobSpawner : Marker2D
{
	[Signal]
	public delegate void WaveClearedEventHandler();

	private Queue<PackedScene> _mobQueue = new Queue<PackedScene>();

	[Export]
	private Base _base;

	public async void StartWave(WaveData wave)
	{
		_mobQueue = new Queue<PackedScene>(wave.Mobs);
		while (_mobQueue.Count > 0)
		{
			Mob mobInstance = _mobQueue.Dequeue().Instantiate<Mob>();
			mobInstance.GlobalPosition = GlobalPosition;
			mobInstance.Init(_base);
			mobInstance.StatsComponent.Died += OnMobDied;
			GetTree().Root.AddChild(mobInstance);

			await ToSignal(GetTree().CreateTimer(wave.SpawnInterval), "timeout");
		}
	}

	private void OnMobDied()
	{
		// The last mob that just died has not exited scene tree yet
		if (GetTree().GetNodesInGroup("mobs").Count == 1 && _mobQueue.Count == 0)
		{
			EmitSignal(nameof(WaveCleared));
		}
	}
}
