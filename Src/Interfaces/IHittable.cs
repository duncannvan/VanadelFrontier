using Godot;

public interface IHittable
{
    public enum States : byte
    {
        MOVE,
        TOOL,
        KNOCKEDBACK,
        DEAD
    }

    public StatsComponent StatsComponent { get; }
    public AnimationPlayer EffectAnimations { get; }

    public void SetState(States newState);
}
