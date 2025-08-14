using Godot;

[GlobalClass]
public sealed partial class Base : StaticBody2D, IHittable
{
	public Hurtbox Hurtbox { get; private set; } = null;
	public StatsComponent StatsComponent { get; private set; } = null;
	public AnimationPlayer HitEffectAnimations { get; private set; } = null;

	public override void _Ready()
	{
		Hurtbox = GetNode<Hurtbox>("Hurtbox");
		StatsComponent = GetNode<StatsComponent>("StatsComponent");
		HitEffectAnimations = GetNode<AnimationPlayer>("HitEffectAnimations");

		Hurtbox.AreaEntered += OnBodyEntered;
		StatsComponent.Died += OnDied;
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
