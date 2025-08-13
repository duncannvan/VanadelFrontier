using Godot;
using System.Collections.Generic;
using System.ComponentModel;

public partial class ToolBar : Control
{
	[Signal]
	public delegate void ToolSlotClickedEventHandler(byte slotIdx);

	private List<TextureButton> toolbar = new List<TextureButton>();

	private Godot.Container toolbarUi;

	public override void _Ready()
	{
		toolbarUi = GetNode<Godot.Container>("%ToolSlotsContainer");
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

	public void UpdateSelectedTool(byte slotIdx)
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

	public void RefreshToolbar(Godot.Collections.Dictionary tools)
	{
		foreach (TextureButton slot in toolbar)
		{
			if (tools.ContainsKey(slot.GetIndex()))
			{
				var slotTextureRect = slot.GetNode<TextureRect>("%ItemTextureRect");
				slotTextureRect.Texture = ((ToolData)tools[slot.GetIndex()]).ToolTexture;
			}
		}
	}

	private void _OnButtonPressed(int slotIdx)
	{
		toolbar[slotIdx].SetPressedNoSignal(!toolbar[slotIdx].ButtonPressed);
		EmitSignal(SignalName.ToolSlotClicked, slotIdx);
	}

	public void StartCooldown(float cooldownSec, byte selectedToolIdx)
	{
		var tween = GetTree().CreateTween();
		var slot = toolbar[selectedToolIdx];
		var cooldownUi = slot.GetNode<ColorRect>("%CooldownUI");
		cooldownUi.Size = new Vector2(cooldownUi.Size.X, slot.Size.Y);
		tween.TweenProperty(cooldownUi, "size:y", 0.0f, cooldownSec);
	}
}
