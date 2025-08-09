using Godot;

namespace Hittable
{
    public enum States : byte
    {
        MOVE,
        TOOL,
        KNOCKEDBACK,
        DEAD
    }

    public interface IHittable
    {
        public StatsComponent StatsComponent { get; }
        public Hurtbox Hurtbox { get; }
        public AnimationPlayer EffectsPlayer { get; }
        public States State { get; set; }
    }
}