using Godot;

public partial class ItemStack : Resource
{
	[Export]
	public ItemResource ItemResource { get; set; }

	[Export]
	public int ItemStackCount { get; set; }

	public ItemStack(ItemResource item = null, int count = 0)
	{
		ItemResource = item;
		ItemStackCount = count;
	}
}
