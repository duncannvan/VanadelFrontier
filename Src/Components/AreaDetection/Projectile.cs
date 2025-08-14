using Godot;

[GlobalClass]
public partial class Projectile : Hitbox
{
    protected byte _speed { get; set; } = 0;
    protected Vector2 _direction { get; set; } = Vector2.Zero;

    public void Init(byte speed, Vector2 direction, Vector2 initialPosition, HitEffect[] hitEffects, float rotation = 0.0f)
    {
        _speed = speed;
        _direction = direction;
        GlobalPosition = initialPosition;
        HitEffects = hitEffects;
        Rotation = rotation;
    }

    public override void _PhysicsProcess(double delta)
    {
        GlobalPosition += _speed * _direction * (float)delta;
    }

    protected override void OnAreaEntered(Area2D area)
    {
        base.OnAreaEntered(area);
        QueueFree();
    }
}