using Godot;

[GlobalClass]
public partial class Hurtbox : Area2D
{
    [Signal]
    public delegate void HurtboxEnteredEventHandler(Hitbox hitbox);

    [Export]
    private bool _isInvincible = false;

    public bool IsInvincible
    {
        get => _isInvincible;
        set
        {
            if (_isInvincible == value) { return; }
            _isInvincible = value;

            foreach (var child in GetChildren())
            {
                if (child is CollisionShape2D || child is CollisionPolygon2D)
                {
                    child.SetDeferred("disabled", value);
                }
            }
        }
    }

}