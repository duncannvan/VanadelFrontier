using Godot;

[GlobalClass]
public partial class Hitbox : Area2D
{
    public HitEffect[] HitEffects { get; set; } = System.Array.Empty<HitEffect>();
    private CollisionObject2D _collisionObject = null;

    public override void _Ready()
    {
        _collisionObject = GetNode<CollisionObject2D>("CollisionObject2D");
        AreaEntered += OnAreaEntered;
    }

    protected virtual void OnAreaEntered(Area2D area)
    {
        if (area as Hurtbox is Hurtbox hb && !hb.IsInvincible)
        {
            hb.EmitSignal(nameof(Hurtbox.HurtboxEntered), this);
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