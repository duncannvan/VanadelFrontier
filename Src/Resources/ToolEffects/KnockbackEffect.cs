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
        CollisionObject2D targetBody = (CollisionObject2D)target;
        Vector2 knockbackVector = hitboxPosition.DirectionTo(targetBody.GlobalPosition) * _knockbackForce;
        target.StatsComponent.ApplyKnockback(target, knockbackVector, _knockbackDuration);
    }
}