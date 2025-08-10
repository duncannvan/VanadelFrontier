using Godot;

[GlobalClass]
public sealed partial class SlowedEffect : ToolEffect
{
    public const float MaxSlowedFactor = 1.0f;

    [Export]
    private float _slowedFactor = MaxSlowedFactor;

    [Export]
    private float _slowedDuration = 0.0f;

    public override void ApplyEffect(IHittable target, Vector2 hitboxPosition)
    {
        target.StatsComponent.ApplySlow(target, _slowedFactor, _slowedDuration);
    }
}