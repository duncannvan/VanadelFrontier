using Godot;

[GlobalClass]
public partial class Mob : CharacterBody2D, IHittable
{
    private IHittable _target;
    private IHittable.States _state = IHittable.States.MOVE;
    private NavigationAgent2D _navAgent;

    public StatsComponent StatsComponent { get; private set; }
    public AnimationPlayer HitEffectAnimations { get; private set; }

    public override void _Ready()
    {
        AddToGroup("mobs");

        StatsComponent = GetNode<StatsComponent>("StatsComponent");
        HitEffectAnimations = GetNode<AnimationPlayer>("HitEffectAnimations");

        _navAgent = GetNode<NavigationAgent2D>("MobNavigation");

        Hitbox hitbox = GetNode<Hitbox>("Hitbox");
        hitbox.HitEffects = StatsComponent.GetHitEffects();

        _navAgent.VelocityComputed += OnVelocityComputed;
    }

    public void Init(IHittable target) => _target = target;

    public override void _PhysicsProcess(double delta)
    {
        if (_target is null || _navAgent is null) { return; }

        _navAgent.TargetPosition = ((Node2D)_target).GlobalPosition;

        // Exit early if the navigation map hasn't been initialized or updated yet or if the agent has already reached its destination
        if (NavigationServer2D.MapGetIterationId(_navAgent.GetNavigationMap()) == 0 || _navAgent.IsNavigationFinished()) { return; }

        Vector2 nextPathPosition = _navAgent.GetNextPathPosition();
        float speed = StatsComponent.GetCurrentSpeed();
        Vector2 newVelocity = GlobalPosition.DirectionTo(nextPathPosition) * speed;

        if (_navAgent.AvoidanceEnabled)
        {
            _navAgent.SetVelocity(newVelocity);
        }
        else
        {
            OnVelocityComputed(newVelocity);
        }
    }

    public void SetState(IHittable.States newState)
    {
        _state = newState;
    }

    private void OnVelocityComputed(Vector2 adjustedVelocity)
    {
        if (_state != IHittable.States.KNOCKBACK)
        {
            Velocity = adjustedVelocity;
        }
        else if (_target == null)
        {
            Velocity = Vector2.Zero;
        }

        MoveAndSlide();
    }
}