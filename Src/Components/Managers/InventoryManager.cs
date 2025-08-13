using Godot;
using System.Collections.Generic;

[GlobalClass]
public sealed partial class InventoryManager : Node
{
	[Signal]
	public delegate void RefreshInventoryEventHandler();

	public const int MaxInventorySize = 10;

	public List<ItemStack> Inventory { get; private set; } = new List<ItemStack>();

	public void AddItem(ItemStack newItemStack)
	{
		if (Inventory.Count > MaxInventorySize)
			return;

		foreach (ItemStack stack in Inventory)
		{
			if (stack.ItemData == newItemStack.ItemData)
			{
				if ((stack.ItemStackCount + newItemStack.ItemStackCount) < ItemStack.MaxCount)
				{
					stack.ItemStackCount += newItemStack.ItemStackCount;
					EmitSignal(SignalName.RefreshInventory);
					return;
				}
				else
				{
					newItemStack.ItemStackCount = ItemStack.MaxCount - stack.ItemStackCount;
					stack.ItemStackCount = ItemStack.MaxCount;
				}
			}
		}

		Inventory.Add(newItemStack);
		EmitSignal(SignalName.RefreshInventory);
	}

	public bool RemoveItem(ItemStack itemStack)
	{
		int numLeftToRemove = itemStack.ItemStackCount;
		List<ItemStack> stacksToRemove = new List<ItemStack>();
		int totalItemCount = GetCount(itemStack.ItemData);

		// Not enough in inventory to remove
		if (itemStack.ItemStackCount > totalItemCount)
			return false;

		// Remove items in inventory
		foreach (ItemStack stack in Inventory)
		{
			if (stack.ItemData == itemStack.ItemData)
			{
				if (stack.ItemStackCount > numLeftToRemove)
				{
					stack.ItemStackCount -= numLeftToRemove;
					break;
				}
				else
				{
					numLeftToRemove -= stack.ItemStackCount;
					stacksToRemove.Add(stack);
				}
			}
		}

		// Remove item stacks
		foreach (var stack in stacksToRemove)
		{
			Inventory.Remove(stack);
		}

		EmitSignal(SignalName.RefreshInventory);
		return true;
	}

	private int GetCount(ItemData item)
	{
		int count = 0;
		foreach (ItemStack stack in Inventory)
		{
			if (stack.ItemData == item)
				count += stack.ItemStackCount;
		}
		return count;
	}
}
