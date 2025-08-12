using Godot;

public sealed partial class Base : StaticBody2D, IHittable
{
	public Hurtbox Hurtbox { get; private set; } = null;
	public StatsComponent StatsComponent { get; private set; } = null;
	public AnimationPlayer EffectAnimations { get; private set; } = null;

	public override void _Ready()
	{
		Hurtbox = GetNode<Hurtbox>("Hurtbox");
		StatsComponent = GetNode<StatsComponent>("StatsComponent");
		EffectAnimations = GetNode<AnimationPlayer>("AnimationPlayer");

		Hurtbox.AreaEntered += OnBodyEntered;
		StatsComponent.Connect("died", new Callable(this, nameof(OnDied)));
	}

	public void SetState(IHittable.States newState) { }

	private void OnBodyEntered(Node body)
	{
		if (body is Mob mob)
		{
			mob.QueueFree();
		}
	}

	private void OnDied()
	{
		//Global.GameOver.Emit();
	}
}
