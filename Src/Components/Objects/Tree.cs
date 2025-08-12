using Godot;

public partial class Tree: Harvestable
{
    public const string TREE_UID = "uid://b8wgn38g22fvs";

    public override Harvestable CreateScene()
    {
        return GD.Load<PackedScene>(TREE_UID).Instantiate<Harvestable>();
    }
}
 