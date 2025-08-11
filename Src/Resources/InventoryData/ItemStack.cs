using Godot;

[GlobalClass]
public sealed partial class ItemStack : Resource
{
	public const byte MaxCount = 99;

	[Export]
	public ItemData ItemData { get; private set; }

	[Export]
	public int ItemStackCount { get; set; }

	public ItemStack(ItemData item, int count = 1) => (ItemData, ItemStackCount) = (item, count);
}
