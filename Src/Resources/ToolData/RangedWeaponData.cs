using System.Diagnostics;
using Godot;

[GlobalClass]
public partial class RangedWeaponData : ToolData
{
    [Export]
    private PackedScene _projectileScene = null;

    [Export]
    private byte _projectileSpeed = 200;

    public override void UseTool(Player player)
    {
        base.UseTool(player);
        Vector2 mousePosition = player.GetViewport().GetCamera2D().GetGlobalMousePosition();
        Vector2 direction = player.GlobalPosition.DirectionTo(mousePosition);


        Debug.Assert(_projectileScene is not null, "Range weapon projectile is null");

        Projectile projectile = _projectileScene.Instantiate<Projectile>();
        projectile.Init(_projectileSpeed, direction, player.GlobalPosition, HitEffects, direction.Angle());
        player.GetParent().AddChild(projectile);
    }
}