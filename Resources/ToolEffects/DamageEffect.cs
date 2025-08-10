using Godot;

[GlobalClass]
public sealed partial class DamageEffect : ToolEffect
{
    [Export]
    private byte _damage = 1;

    public override void ApplyEffect(IHittable target, Vector2 hitboxPosition)
    {
        target.StatsComponent.ApplyDamage(target, _damage);        
    }
}