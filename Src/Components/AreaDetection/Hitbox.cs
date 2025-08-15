using System.Diagnostics;
using Godot;

[GlobalClass]
public partial class Hitbox : Area2D
{
    public HitEffect[] HitEffects { get; set; } = System.Array.Empty<HitEffect>();
    private CollisionShape2D _collisionObject = null;

    public override void _Ready()
    {
        _collisionObject = GetNode<CollisionShape2D>("CollisionShape2D");
        Debug.Assert(_collisionObject is not null, "Hitbox's collision object is null");
        AreaEntered += OnAreaEntered;
    }

    protected virtual void OnAreaEntered(Area2D area)
    {
        if (area as Hurtbox is not Hurtbox hurtbox || hurtbox.IsInvincible) { return; }

        if (hurtbox.Owner is IHittable target)
        {
            foreach (HitEffect effect in HitEffects)
            {
                effect.ApplyEffect(target, GlobalPosition);
            }
        }
    }

    public void DisableHitbox()
    {
        _collisionObject.SetDeferred("disabled", true);
    }

    public void EnableHitbox()
    {
        _collisionObject.SetDeferred("disabled", false);
    }
}