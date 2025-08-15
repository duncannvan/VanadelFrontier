using Godot;
using System.Collections.Generic;
using System;
using static MobSpawnData.TargetType;

[GlobalClass]
public sealed partial class WaveManager : Marker2D
{
	[Signal]
	public delegate void WaveClearedEventHandler(uint wavePeriodSec);

	public const uint WavePeriodSec = 2;

	private Queue<MobSpawnData> _mobGroupQueue = new Queue<MobSpawnData>();
	private byte _currentWave = 0;
	private MobSpawnData _queuedMobGroup;
	private Dictionary<MobSpawnData.TargetType, IHittable> _targets;
	private byte _numWaveMobs;

	[Export]
	private WaveData[] _waves = Array.Empty<WaveData>();

	public void Init(IHittable homeBase, IHittable player)
	{
		_targets = new Dictionary<MobSpawnData.TargetType, IHittable> { { BASE, homeBase }, { PLAYER, player } };
	}

	public void StartWave()
	{
		if (_currentWave < _waves.Length)
		{
			_mobGroupQueue = new Queue<MobSpawnData>(_waves[_currentWave].MobWaveData);

			foreach (MobSpawnData data in _waves[_currentWave].MobWaveData) { _numWaveMobs += data.Count; }

			_queuedMobGroup = _mobGroupQueue.Dequeue();
			GetTree().CreateTimer(_queuedMobGroup.DelaySpawnSec).Timeout += SpawnWaveMobs;
		}
	}

	private void SpawnWaveMobs()
	{
		for (byte i = 0; i < _queuedMobGroup.Count; i++)
		{
			Mob mobInstance = _queuedMobGroup.MobScene.Instantiate<Mob>();
			mobInstance.GlobalPosition = GlobalPosition;
			switch (_queuedMobGroup.Target)
			{
				case BASE:
					mobInstance.Init(_targets[BASE]);
					break;
				case PLAYER:
					mobInstance.Init(_targets[PLAYER]);
					break;
			}

			GetTree().Root.AddChild(mobInstance);
			mobInstance.StatsComponent.Died += OnMobDied;
		}

		if (_mobGroupQueue.Count > 0)
		{
			_queuedMobGroup = _mobGroupQueue.Dequeue();
			GetTree().CreateTimer(_queuedMobGroup.DelaySpawnSec).Timeout += SpawnWaveMobs;
		}
	}

	private void OnMobDied()
	{
		if (--_numWaveMobs == 0)
		{
			EmitSignal(nameof(WaveCleared), WavePeriodSec);
			_currentWave++;
		}
	}
}