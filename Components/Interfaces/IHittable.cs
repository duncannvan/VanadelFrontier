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
    public Hurtbox Hurtbox { get; }
    public Hitbox Hitbox { get; }
    public AnimationPlayer EffectsPlayer { get; }

    public void SetState(IHittable.States newState);
}
