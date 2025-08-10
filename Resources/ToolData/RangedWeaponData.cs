using Godot;

public partial class RangedWeaponData : ToolData
{
    [Export]
    private PackedScene ProjectileScene { get; set; } = null;

    [Export]
    private byte _projectileSpeed = 200;

    public override void UseTool(Player player)
    {
        base.UseTool(player);
        Vector2 mousePosition = player.GetViewport().GetCamera2D().GetGlobalMousePosition();
        Vector2 direction = player.GlobalPosition.DirectionTo(mousePosition);

        Projectile projectile = ProjectileScene.Instantiate<Projectile>();
        projectile.Init(_projectileSpeed, direction, player.GlobalPosition, HitEffects, direction.Angle());
    }
}