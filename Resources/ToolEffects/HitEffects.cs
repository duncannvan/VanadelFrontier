using Godot;

public abstract partial class HitEffect : Resource
{
    public abstract void ApplyEffect(IHittable target, Vector2 hitboxPosition);
}
