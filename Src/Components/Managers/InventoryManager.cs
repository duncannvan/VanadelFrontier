using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

[GlobalClass]
public sealed partial class InventoryManager : Node
{
	[Signal]
	public delegate void RefreshInventoryEventHandler();

	public const int MaxInventorySize = 10;

	private List<ItemStack> inventory = new List<ItemStack>();

	public void AddItem(ItemData item)
	{
		if (inventory.Count >= MaxInventorySize)
			return;

		foreach (ItemStack stack in inventory)
		{
			if (stack.ItemData == item && stack.ItemStackCount < ItemStack.MaxCount)
			{
				stack.ItemStackCount++;
				EmitSignal(SignalName.RefreshInventory);
				return;
			}
		}

		inventory.Add(new ItemStack(item));
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
		foreach (ItemStack stack in inventory)
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
			inventory.Remove(stack);
		}

		EmitSignal(SignalName.RefreshInventory);
		return true;
	}

	public int GetCount(ItemData item)
	{
		int count = 0;
		foreach (ItemStack stack in inventory)
		{
			if (stack.ItemData == item)
				count += stack.ItemStackCount;
		}
		return count;
	}

	public List<ItemStack> GetInventory()
	{
		return inventory;
	}
}
