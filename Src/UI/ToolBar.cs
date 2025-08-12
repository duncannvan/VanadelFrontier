using Godot;
using System;
using System.Collections.Generic;

public partial class ToolBar : Control
{
	[Signal]
	public delegate void ToolSlotClickedEventHandler(int slotIdx);

	private int _slotIdx = ToolManager.NoToolSelected;
	private List<TextureButton> toolbar = new List<TextureButton>();

	private Container toolbarUi;

	public override void _Ready()
	{
		toolbarUi = GetNode<Container>("%ToolSlotsContainer");
		foreach (Node child in toolbarUi.GetChildren())
		{
			if (child is TextureButton slot)
			{
				toolbar.Add(slot);
				int idx = slot.GetIndex();
				slot.Pressed += () => _OnButtonPressed(idx);
			}
		}
	}

	public void UpdateSelectedTool(int slotIdx)
	{
		foreach (TextureButton slot in toolbar)
		{
			if (slot.GetIndex() == slotIdx)
			{
				slot.SetPressedNoSignal(!slot.ButtonPressed);
			}
			else
			{
				slot.SetPressedNoSignal(false);
			}
		}
	}

	public void RefreshToolbar(ToolData[] tools)
	{
		foreach (TextureButton slot in toolbar)
		{
			int idx = slot.GetIndex();
			if (idx < tools.Length && tools[idx] is not null)
			{
				var slotTextureRect = slot.GetNode<TextureRect>("%ItemTextureRect");
				slotTextureRect.Texture = (tools[idx]).ToolTexture;
			}
		}
	}

	private void _OnButtonPressed(int slotIdx)
	{
		toolbar[slotIdx].SetPressedNoSignal(!toolbar[slotIdx].ButtonPressed);
		EmitSignal(SignalName.ToolSlotClicked, slotIdx);
	}

	public void StartCooldown(float cooldownSec, int selectedToolIdx)
	{
		var tween = GetTree().CreateTween();
		var slot = toolbar[selectedToolIdx];
		var cooldownUi = slot.GetNode<ColorRect>("%CooldownUI");
		cooldownUi.Size = new Vector2(cooldownUi.Size.X, slot.Size.Y);
		tween.TweenProperty(cooldownUi, "size:y", 0.0f, cooldownSec);
	}
}
