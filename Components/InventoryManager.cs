using Godot;
using System;
using System.Collections.Generic;

public partial class InventoryManager : Node
{
	[Signal]
	public delegate void RefreshInventoryEventHandler();

	public const int MAX_INVENTORY_SIZE = 10;
	public const int MAX_STACKS = 99;

	private List<ItemStack> inventory = new List<ItemStack>();

	public void AddItem(ItemData item)
	{
		if (inventory.Count >= MAX_INVENTORY_SIZE)
			return;

		foreach (ItemStack stack in inventory)
		{
			if (stack.item_resource == item && stack.item_stack_count < MAX_STACKS)
			{
				stack.item_stack_count += 1;
				EmitSignal(SignalName.RefreshInventory);
				return;
			}
		}

		inventory.Add(new ItemStack(item, 1));
		EmitSignal(SignalName.RefreshInventory);
	}

	public bool RemoveItem(ItemStack itemStack)
	{
		int numLeftToRemove = itemStack.item_stack_count;
		List<ItemStack> stacksToRemove = new List<ItemStack>();
		int totalItemCount = GetCount(itemStack.item_resource);

		// Not enough in inventory to remove
		if (itemStack.item_stack_count > totalItemCount)
			return false;

		// Remove items in inventory
		foreach (ItemStack stack in inventory)
		{
			if (stack.item_resource == itemStack.item_resource)
			{
				if (stack.item_stack_count > numLeftToRemove)
				{
					stack.item_stack_count -= numLeftToRemove;
					break;
				}
				else
				{
					numLeftToRemove -= stack.item_stack_count;
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
			if (stack.item_resource == item)
				count += stack.item_stack_count;
		}
		return count;
	}

	public List<ItemStack> GetInventory()
	{
		return inventory;
	}
}
