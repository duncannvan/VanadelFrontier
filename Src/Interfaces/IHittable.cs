using Godot;

public interface IHittable
{
    public enum States : byte
    {
        IDLE,
        MOVE,
        TOOL,
        KNOCKBACK,
        DEAD
    }

    public StatsComponent StatsComponent { get; }
    public AnimationPlayer EffectAnimations { get; }

    public void SetState(States newState);
}
