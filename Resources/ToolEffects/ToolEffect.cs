using Godot;

public abstract partial class ToolEffect : Resource
{
    public abstract void ApplyEffect(IHittable target, Vector2 hitboxPosition);
}
