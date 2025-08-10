using Godot;

[GlobalClass]
public partial class TowerProjectile : Projectile
{
    private Mob _target = null;

    public void Init(Mob target, byte speed, Vector2 initialPosition, HitEffect[] hitEffects)
    {
        Init(speed, Vector2.Zero, initialPosition, hitEffects);
        _target = target;
    }

    public override void _PhysicsProcess(double delta)
    {
        if (_target is null)
        {
            QueueFree();
            return;
        }

        LookAt(_target.GlobalPosition);
        _direction = GlobalPosition.DirectionTo(_target.GlobalPosition);
        base._PhysicsProcess(delta);
    }
}