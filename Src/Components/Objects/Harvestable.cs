using Godot;
using System;

public abstract partial class Harvestable : StaticBody2D, IHittable
{
    [Signal]
    public delegate void ItemDroppedEventHandler(ItemData item);

    [Signal]
    public delegate void DiedEventHandler(Harvestable obj);

    [Export]
    public ItemData DroppedItem { get; private set; } = null;
    
    [Export]
    public int RespawnTimeSec { get; private set; } = 10;
    
    private Hurtbox _hurtbox = null;
    public StatsComponent StatsComponent { get; private set; } = null;
    public AnimationPlayer EffectAnimations { get; private set; } = null;

    public override void _Ready()
    {
        AddToGroup("harvestables");
        _hurtbox = GetNode<Hurtbox>("Hurtbox");
        StatsComponent = GetNode<StatsComponent>("StatsComponent");
        EffectAnimations = GetNode<AnimationPlayer>("EffectAnimations");

        _hurtbox.BodyEntered += OnBodyEntered; // TODO: Double check using AreaEntered
        StatsComponent.Died += Die;
    }

    public abstract Harvestable CreateScene();

    public void SetState(IHittable.States newState) { }

    private void OnBodyEntered(Node body)
    {
        if (body is Player && DroppedItem != null)
        {
            EmitSignal(SignalName.ItemDropped, DroppedItem);
        }
    }

    private void Die()
    {
        EmitSignal(SignalName.Died, this);
    }
}
