using System.Diagnostics;
using System.Linq;
using Godot;

[GlobalClass]
public partial class MeleeWeaponData : ToolData
{
    public override float ToolCooldownSec
    {
        get
        {
            Debug.Assert(AnimationLibraries.Length > 0, "Tool animation library is empty");
            AnimationLibrary animationLib = AnimationLibraries[AnimationLibrariesIdx];
            string animationStr = animationLib.GetAnimationList().First();
            if (AnimationLibrariesIdx >= AnimationLibraries.Length - 1)
            {
                return animationLib.GetAnimation(animationStr).GetLength() + base.ToolCooldownSec;
            }
            return animationLib.GetAnimation(animationStr).GetLength();
        }
        protected set => base.ToolCooldownSec = value;
    }
}