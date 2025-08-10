using Godot;

[GlobalClass]
public partial class ToolData : Resource
{
    [Export]
    public string ToolName { get; private set; } = "";

    [Export]
    public Texture2D ToolIcon { get; private set; } = null;

    [Export]
    public virtual float ToolCooldownSec { get; private set; } = 0.0f;

    [Export]
    public AnimationLibrary[] AnimationLibraries { get; private set; } = System.Array.Empty<AnimationLibrary>();

    [Export]
    protected HitEffect[] HitEffects { get; private set; } = System.Array.Empty<HitEffect>();

    public bool IsCooldownActive { get; set; } = false;
    public byte AnimationLibrariesIdx { get; private set; } = 0;

    public virtual void UseTool(Player player)
    {
        player.SetState(IHittable.States.TOOL);
        IncrementAnimationLibrariesIdx();
    }

    public virtual void OnSwitchIn(Player player)
    {
        player.Hitbox.HitEffects = HitEffects;
    }

    public virtual void OnSwitchOut(Player player) { }

    public void ResetAnimationLibrariesIdx()
    {
        AnimationLibrariesIdx = 0;
    }

    private void IncrementAnimationLibrariesIdx()
    {
        if (AnimationLibraries.Length == 0) { return; }

        if (++AnimationLibrariesIdx >= AnimationLibraries.Length)
        {
            AnimationLibrariesIdx = 0;
        }
    }
}