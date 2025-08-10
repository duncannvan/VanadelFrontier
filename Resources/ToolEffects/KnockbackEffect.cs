using Godot;

[GlobalClass]
public sealed partial class KnockbackEffect : HitEffect
{
    [Export]
    private byte _knockbackForce = 200;

    [Export]
    private float _knockbackDuration = 0.1f;

    public override void ApplyEffect(IHittable target, Vector2 hitboxPosition)
    {
        Vector2 knockbackVector = hitboxPosition.DirectionTo(target.Hurtbox.GlobalPosition) * _knockbackForce;
        target.StatsComponent.ApplyKnockback(target, knockbackVector, _knockbackDuration);
    }
}