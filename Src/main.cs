using Godot;

public sealed partial class Main : Node2D
{
	private StatsComponent _baseStatsComponent;
	private WaveManager _waveManager;
	private TextureProgressBar _baseHealthBar;
	private Player _player;
	private InventoryManager _inventoryManager;
	private NatureSpawner _natureSpawner;
	private UIManager _uiManager;
	private WaveCountdown _waveCountDown;

	public override void _Ready()
	{
		_baseStatsComponent = GetNode<StatsComponent>("Base/StatsComponent");
		_waveManager = GetNode<WaveManager>("WaveManager");
		//_baseHealthBar = GetNode<TextureProgressBar>("UI/BaseHealthBar");
		_player = GetNode<Player>("Player");
		_natureSpawner = GetNode<NatureSpawner>("NatureSpawner");
		_uiManager = GetNode<UIManager>("UIManager");
		_waveCountDown = GetNode<WaveCountdown>("UI/WaveCountdown");
		_uiManager.Init(_player);
		_waveManager.Init(GetNode<Base>("Base"), _player);
		_waveManager.WaveCleared += _waveCountDown.StartCountdown;
		_waveCountDown.StartWave += _waveManager.StartWave;
		_waveCountDown.StartCountdown(WaveManager.WavePeriodSec);


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
	}

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