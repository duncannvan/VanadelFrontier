using Godot;
using System;

public abstract partial class Harvestable : StaticBody2D, IHittable
{
    [Signal]
    public delegate void DiedEventHandler(Harvestable obj);
    
    [Export]
    public int RespawnTimeSec { get; private set; } = 10;
    
    public StatsComponent StatsComponent { get; private set; }
    public AnimationPlayer EffectAnimations { get; private set; }

    public override void _Ready()
    {
        AddToGroup("harvestables");
        StatsComponent = GetNode<StatsComponent>("StatsComponent");
        EffectAnimations = GetNode<AnimationPlayer>("EffectAnimations");

        StatsComponent.Died += () => { EmitSignal(SignalName.Died, this); };
    }

    public abstract Harvestable CreateScene();

    public virtual void SetState(IHittable.States newState) { }
}
