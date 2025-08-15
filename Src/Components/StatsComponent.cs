using System.Diagnostics;
using Godot;

[GlobalClass]
public sealed partial class StatsComponent : Node
{
    [Signal]
    public delegate void DiedEventHandler();

    [Signal]
    public delegate void HealthChangedEventHandler(float newHealth);

    [Signal]
    public delegate void LootDroppedEventHandler(ItemStack item);

    private Timer _slowedTimer;
    private Timer _knockbackTimer;
    private Vector2 _knockbackVector;
    private float _slowedFactor = SlowedEffect.MaxSlowedFactor;

    [Export]
    private StatsSheet _statsSheet;

    public override void _Ready()
    {
        Debug.Assert(_statsSheet is not null, "Stats sheet is null");

        _slowedTimer = new Timer();
        _slowedTimer.OneShot = true;
        AddChild(_slowedTimer);

        _knockbackTimer = new Timer();
        _knockbackTimer.OneShot = true;
        AddChild(_knockbackTimer);
    }

    public void ApplyDamage(IHittable target, byte damage)
    {
        if (damage <= 0) { return; }

        _statsSheet.Health -= damage;

        EmitSignal(nameof(HealthChanged), _statsSheet.Health);

        if (target.HitEffectAnimations.HasAnimation("damage_effect"))
        {
            target.HitEffectAnimations.Play("damage_effect");
        }

        if (_statsSheet.Health <= 0)
        {
            ApplyDied(target);
        }
    }

    public byte GetHealth()
    {
        return _statsSheet.Health;
    }

    public void ApplyKnockback(IHittable target, Vector2 vector, float duration)
    {
        if (duration <= 0 || !_knockbackTimer.IsStopped()) { return; }

        target.SetState(IHittable.States.KNOCKBACK);

        if (target.HitEffectAnimations.HasAnimation("knockback_effect"))
        {
            target.HitEffectAnimations.Play("knockback_effect");
        }

        _knockbackVector = vector;
        _knockbackTimer.Timeout += () => target.SetState(IHittable.States.MOVE);
        _knockbackTimer.Start(duration);
    }

    public Vector2 GetKnockbackVector()
    {
        return _knockbackVector;
    }

    public void ApplySlow(IHittable target, float factor, float duration)
    {
        if (duration <= 0) { return; }

        if (_slowedFactor != factor)
        {
            _slowedFactor = factor;
        }

        _slowedTimer.Timeout += () => OnSlowedTimeout(target);
        _slowedTimer.Start(duration);

        if (target.HitEffectAnimations.HasAnimation("slowed_effect"))
        {
            target.HitEffectAnimations.Play("slowed_effect");
        }
    }

    public float GetCurrentSpeed()
    {
        return _statsSheet.Speed * _slowedFactor;
    }

    private void OnSlowedTimeout(IHittable target)
    {
        _slowedFactor = SlowedEffect.MaxSlowedFactor;
        if (target.HitEffectAnimations.IsPlaying())
        {
            target.HitEffectAnimations.Seek(0, false);
            target.HitEffectAnimations.Stop();
        }
    }

    private void ApplyDied(IHittable target)
    {
        target.SetState(IHittable.States.DEAD);

        if (target.HitEffectAnimations.HasAnimation("death_effect"))
        {
            target.HitEffectAnimations.Play("death_effect");
        }

        if (target.StatsComponent.GetItemDrop() is not null)
        {
            EmitSignal(nameof(LootDropped), target.StatsComponent.GetItemDrop());
        }

        EmitSignal(nameof(Died));

        if (target is Node node)
        {
            node.QueueFree();
        }
    }

    public ItemStack GetItemDrop()
    {
        return _statsSheet.ItemDropped;
    }

    public HitEffect[] GetHitEffects()
    {
        return _statsSheet.HitEffects;
    }
}