using Godot;

public partial class BaseHealth : Control
{
	private TextureProgressBar _healthBar;

	public override void _Ready()
	{
		_healthBar = GetNode<TextureProgressBar>("%HealthBar");
	}

	public void Initialize(int health)
	{
		_healthBar.MaxValue = health;
		_healthBar.Value = health;
	}

	public void UpdateHealth(int health)
	{
		_healthBar.Value = health;
	}
}
