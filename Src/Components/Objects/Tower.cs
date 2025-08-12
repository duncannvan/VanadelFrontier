using Godot;
using System.Collections.Generic;
using System.Linq;

public partial class Tower : StaticBody2D
{
	[Export]
	public TowerData TowerData = null;

	[Export]
	public bool Enabled = true; // Debug build only

	private Mob _currentTarget = null;
	private List<Mob> _mobsInRange = new List<Mob>();

	private Timer _fireRateTimer = null;
	private Area2D _atkRange = null;

	public override void _Ready()
	{
		_fireRateTimer = GetNode<Timer>("FireRateTimer");
		_atkRange = GetNode<Area2D>("Range");

		_atkRange.BodyEntered += OnBodyEntered;
		_atkRange.BodyExited += OnBodyExited;
		_fireRateTimer.Timeout += OnShootTimerTimeout;
	}

	private void OnBodyExited(Node body)
	{
		if (body is Mob mob)
		{
			_mobsInRange.Remove(mob);
			_currentTarget = null;
		}
	}

	private void OnBodyEntered(Node body)
	{
		if (!Enabled) { return; }

		if (body is Mob mob)
		{
			_mobsInRange.Add(mob);
			if (_currentTarget == null)
			{
				_currentTarget = mob;
				_fireRateTimer.Start();
			}
		}
	}

	private void OnShootTimerTimeout()
	{
		if (_mobsInRange.Count > 0)
		{
			_currentTarget = _mobsInRange.First();
		}

		if (_currentTarget != null)
		{
			SpawnProjectile();
		}
		else
		{
			_fireRateTimer.Stop();
		}
	}

	private void SpawnProjectile()
	{
		TowerProjectile projectile = TowerData.Projectile.Instantiate<TowerProjectile>();
		projectile.Init(_currentTarget, TowerData.ProjectileSpeed, GlobalPosition, TowerData.HitEffects);
		GetParent().AddChild(projectile);
	}
}
