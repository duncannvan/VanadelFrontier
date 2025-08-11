using Godot;

[GlobalClass]
public sealed partial class ItemData : Resource
{
	[Export]
	public string Name { get; private set; } = "";

	[Export]
	public Texture2D Texture { get; private set; } = null;
}