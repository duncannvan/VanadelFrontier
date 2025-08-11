using System.Diagnostics;
using Godot;

[GlobalClass]
public sealed partial class StatsComponent : Node
{
    [Signal]
    public delegate void DiedEventHandler();

    [Signal]
    public delegate void HealthChangedEventHandler(float newHealth);

    [Export]
    private StatsSheet _statsSheet = null;
    
    private Timer _slowedTimer = null;
    private Timer _knockbackTimer = null;
    private Vector2 _knockbackVector = Vector2.Zero;
    private float _slowedFactor = SlowedEffect.MaxSlowedFactor;

    public override void _Ready()
    {
        Debug.Assert(_statsSheet is not null, "Stats sheet is null");

        _slowedTimer = new Timer();
        _slowedTimer.SetOneShot(true);
        AddChild(_slowedTimer);

        _knockbackTimer = new Timer();
        _knockbackTimer.SetOneShot(true);
        AddChild(_knockbackTimer);
    }

    public void ApplyDamage(IHittable target, byte damage)
    {
        if (damage <= 0) { return; }

        _statsSheet.Health -= damage;

        EmitSignal(nameof(HealthChangedEventHandler), _statsSheet.Health);

        if (target.EffectsPlayer.HasAnimation("damage_effect"))
        {
            target.EffectsPlayer.Play("damage_effect");
        }

        if (_statsSheet.Health <= 0)
        {
            EmitSignal(nameof(DiedEventHandler));
        }
    }

    public float GetHealth()
    {
        return _statsSheet.Health;
    }

    public void ApplyKnockback(IHittable target, Vector2 vector, float duration)
    {
        if (duration <= 0 || !_knockbackTimer.IsStopped()) { return; }

        target.SetState(IHittable.States.KNOCKEDBACK);

        if (target.EffectsPlayer.HasAnimation("knockback_effect"))
        {
            target.EffectsPlayer.Play("knockback_effect");
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

        if (target.EffectsPlayer.HasAnimation("slowed_effect"))
        {
            target.EffectsPlayer.Play("slowed_effect");
        }
    }

    public float GetCurrentSpeed()
    {
        return _statsSheet.Speed * _slowedFactor;
    }

    private void OnSlowedTimeout(IHittable target)
    {
        _slowedFactor = SlowedEffect.MaxSlowedFactor;
        if (target.EffectsPlayer.IsPlaying())
        {
            target.EffectsPlayer.Seek(0, false);
            target.EffectsPlayer.Stop();
        }
    }
}