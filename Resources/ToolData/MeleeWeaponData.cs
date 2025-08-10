using System.Linq;
using Godot;

public partial class MeleeWeaponData : ToolData
{
    public override float ToolCooldownSec
    {
        get
        {
            AnimationLibrary animationLib = AnimationLibraries[AnimationLibrariesIdx];
            string animationStr = animationLib.GetAnimationList().First();
            if (AnimationLibrariesIdx >= AnimationLibraries.Length)
            {
                return animationLib.GetAnimation(animationStr).GetLength() + base.ToolCooldownSec;
            }
            return animationLib.GetAnimation(animationStr).GetLength();
        }
    }
}