using Godot;
using System;

public partial class Main : Node2D
{
	private byte _currentWave = 0;

	[Export]
	private WaveData[] _waves = Array.Empty<WaveData>();

	private Timer _waveCountdownTimer = null;
	private StatsComponent _baseStatsComponent;
	private MobSpawner _mobSpawner;
	private TextureProgressBar _baseHealthBar;
	private Player _player;
	private InventoryManager _inventoryManager;
	private NatureSpawner _natureSpawner;
	private UIManager _UiManager;

	public override void _Ready()
	{
		_waveCountdownTimer = GetNode<Timer>("WaveCountdownTimer");
		_baseStatsComponent = GetNode<StatsComponent>("Base/StatsComponents");
		_mobSpawner = GetNode<MobSpawner>("MobSpawner");
		//_baseHealthBar = GetNode<TextureProgressBar>("UI/BaseHealthBar");
		_player = GetNode<Player>("Player");
		_natureSpawner = GetNode<NatureSpawner>("NatureSpawner");
		_UiManager = GetNode<UIManager>("UIManager");
		_UiManager.Init(_player);
		//5_waveCountdownTimer.Timeout += StartWave;
		// if (_mobSpawner != null)
		// 	_mobSpawner.WaveCleared += StartWaveCountdown;
		// _baseStatsComponent.Died += OnBaseDied;
		// _baseStatsComponent.HealthChanged += OnHealthChanged;
		//_baseHealthBar.Call("initialize", _baseStatsComponent.Call("get_health"));


		//_natureSpawner.Connect("child_entered_tree", new Callable(this, nameof(OnNatureObjRespawned)));

		// foreach (Harvestable obj in GetTree().GetNodesInGroup("nature_objects"))
		// {

		// 	obj.ItemDropped += OnLootDropped;
		// }

		//StartWaveCountdown();
	}

	// private void StartWave()
	// {
	// 	if (_mobSpawner != null && _waves != null && _currentWave < _waves.Length)
	// 	{
	// 		_mobSpawner.StartWave(_waves[_currentWave]);
	// 		_currentWave++;
	// 	}
	// }

	// private void StartWaveCountdown()
	// {
	// 	if (_waves == null || _currentWave >= _waves.Length)
	// 		return;
	// 	//_waveCountdownTimerUi.Call("start_countdown", _waveCountdownTimer);
	// 	_waveCountdownTimer.Start(1);
	// }

	// private void OnBaseDied()
	// {
	// 	if (_mobSpawner != null)
	// 		_mobSpawner.Call("disable");
	// }

	private void OnHealthChanged(float newHealth)
	{
		_baseHealthBar.Call("update", _baseStatsComponent.Call("get_health"));
	}

	private void OnLootDropped(ItemStack item)
	{
		_inventoryManager.AddItem(item);
	}

	private void OnMobSpawned(Mob mob)
	{
		mob.Connect("loot_dropped", new Callable(this, nameof(OnLootDropped)));
	}

	private void OnNatureObjRespawned(Harvestable harvestable)
	{
		harvestable.Died += _natureSpawner.HandleRespawn;
		harvestable.StatsComponent.LootDropped += OnLootDropped;
	}
}