using Godot;
using System;

public partial class CraftingTable : StaticBody2D
{
	[Signal]
	public delegate void CraftingRangeStatusEventHandler(bool inRange);

	private Area2D _craftingRange;
	public bool PlayerInRange = false;

	public override void _Ready()
	{
		_craftingRange = GetNode<Area2D>("Area2D");
		_craftingRange.BodyEntered += OnAreaEntered;
		_craftingRange.BodyExited += OnAreaExited;
	}

	private void OnAreaEntered(Node body)
	{
		if (body is Player)
		{
			PlayerInRange = true;
			EmitSignal(SignalName.CraftingRangeStatus, PlayerInRange);
		}
	}

	private void OnAreaExited(Node body)
	{
		if (body is Player)
		{
			PlayerInRange = false;
			EmitSignal(SignalName.CraftingRangeStatus, PlayerInRange);
		}
	}
}
