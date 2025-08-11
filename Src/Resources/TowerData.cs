using System.Dynamic;
using Godot;

[GlobalClass]
public sealed partial class TowerData : Resource
{
    [Export]
    public PackedScene Projectile { get; private set; } = null;

    [Export]
    public HitEffect[] HitEffects { get; private set; } = System.Array.Empty<HitEffect>();

    [Export]
    public ItemStack CraftRecipe { get; private set; } = null;

    [Export]
    public byte ProjectileSpeed { get; private set; } = 100;
}
