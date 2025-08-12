using Godot;

public partial class RockObject : Harvestable
{
    public const string ROCK_UID = "uid://bq8enjaug7mue";

    public override Harvestable CreateScene()
    {
        return GD.Load<PackedScene>(ROCK_UID).Instantiate<Harvestable>();
    }
}
