using System.Collections.Generic;
using Godot;

[GlobalClass]
public sealed partial class ToolManager : Node
{
    [Signal]
    public delegate void ToolSelectionChangedEventHandler(byte newSlotIdx);

    [Signal]
    public delegate void ToolBarModifiedEventHandler(Godot.Collections.Dictionary toolData);

    [Signal]
    public delegate void ToolUsedEventHandler(byte cooldown, byte slotIdx);

    public const byte NoToolSelected = 0;
    private const byte MaxToolSlots = 5;
    private const float CooldownResetTimeSec = 0.5f;

    private byte _currentToolIdx = NoToolSelected;
    private Dictionary<byte, ToolData> _toolData = new Dictionary<byte, ToolData>();
    private readonly Dictionary<string, byte> _blendPointIdxMap = new Dictionary<string, byte>() { { "left", 0 }, { "right", 0 }, { "up", 0 }, { "down", 0 } };
    private Timer _resetAnimationTimer;

    public override void _Ready()
    {
        _resetAnimationTimer = new Timer();
        _resetAnimationTimer.SetOneShot(true);
        _resetAnimationTimer.Timeout += () => { GetSelectedTool().ResetAnimationLibrariesIdx(); };
        AddChild(_resetAnimationTimer);

        // Temporary load tools for now. Player will probably spawn with nothing in the future
        byte slotIdx = 1;
        _toolData.Add(slotIdx++, (ToolData)GD.Load("res://Data/Tools/StarterHarvestTool.tres"));
        _toolData.Add(slotIdx++, (ToolData)GD.Load("res://Data/Tools/StarterMeleeWeapon.tres"));
        _toolData.Add(slotIdx++, (ToolData)GD.Load("res://Data/Tools/StarterRangedWeapon.tres"));
    }

    public void SetSelectedTool(Player player, byte slotIdx)
    {
        if (slotIdx > MaxToolSlots) { return; }

        if (IsToolSelected()) { GetSelectedTool().ResetAnimationLibrariesIdx(); }
        if (!_resetAnimationTimer.IsStopped()) { _resetAnimationTimer.Stop(); }
        ;
        EmitSignal(nameof(ToolSelectionChanged), slotIdx);

        if (!_toolData.ContainsKey(slotIdx) || slotIdx == _currentToolIdx)
        {
            _currentToolIdx = NoToolSelected;
        }
        else
        {
            if (IsToolSelected()) { GetSelectedTool().OnSwitchIn(player); }
            _currentToolIdx = slotIdx;
            GetSelectedTool().OnSwitchOut(player);
            SetToolAnimation(player.AnimationTree);
        }
    }

    public void UseSelectedTool(Player player)
    {
        if (!IsToolSelected()) { return; }
        if (GetSelectedTool().IsCooldownActive) { return; }

        byte usedToolIdx = _currentToolIdx;
        float cooldownSec = GetSelectedTool().ToolCooldownSec;
        GetSelectedTool().IsCooldownActive = true;

        // Iterate to next animation if tool has more an 1 animations
        if (GetSelectedTool().AnimationLibraries.Length > 1)
        {
            SetToolAnimation(player.AnimationTree, GetSelectedTool().AnimationLibrariesIdx);
            _resetAnimationTimer.Start(cooldownSec + CooldownResetTimeSec);
        }

        EmitSignal(nameof(ToolUsed), cooldownSec, _currentToolIdx);
        GetSelectedTool().UseTool(player);
        GetTree().CreateTimer(cooldownSec).Timeout += () => { _toolData[usedToolIdx].IsCooldownActive = false; };
    }

    public bool IsToolSelected() { return _toolData.ContainsKey(_currentToolIdx); }

    public void RemoveTool(byte slotIdx)
    {
        if (_toolData.ContainsKey(slotIdx))
        {
            _toolData.Remove(slotIdx);
            EmitSignal(nameof(ToolBarModified), GetToolsGodotDict());
        }
    }

    public bool AddTool(ToolData toolData)
    {
        if (_toolData.Count > MaxToolSlots) { return false; }

        for (byte slotPos = 1; slotPos <= MaxToolSlots; slotPos++)
        {
            if (!_toolData.ContainsKey(slotPos))
            {
                _toolData.Add(slotPos, toolData);
                EmitSignal(nameof(ToolBarModified), GetToolsGodotDict());
                return true;
            }
        }
        return false;
    }

    public void SwapToolSlots(byte slotIdx1, byte slotIdx2)
    {
        if (_toolData.Count > slotIdx1 && _toolData.Count > slotIdx2)
        {
            (_toolData[slotIdx1], _toolData[slotIdx2]) = (_toolData[slotIdx2], _toolData[slotIdx1]);
            EmitSignal(nameof(ToolBarModified), GetToolsGodotDict());
        }
    }

    public void SetBlendPointIdxMapping(AnimationTree animationTree)
    {
        AnimationNodeBlendTree root = animationTree.TreeRoot as AnimationNodeBlendTree;
        AnimationNodeStateMachine stateMachine = root.GetNode("StateMachine") as AnimationNodeStateMachine;
        AnimationNodeBlendSpace2D blendSpace = stateMachine.GetNode("ToolState") as AnimationNodeBlendSpace2D;

        for (byte blendSpaceIdx = 0; blendSpaceIdx < blendSpace.GetBlendPointCount(); blendSpaceIdx++)
        {
            Vector2 blendPointPos = blendSpace.GetBlendPointPosition(blendSpaceIdx);
            string direction = VectorToDirection(blendPointPos);
            _blendPointIdxMap[direction] = blendSpaceIdx;
        }
    }

    private void SetToolAnimation(AnimationTree animationTree, byte libIdx = 0)
    {
        AnimationNodeBlendTree root = animationTree.TreeRoot as AnimationNodeBlendTree;
        AnimationNodeStateMachine stateMachine = root.GetNode("StateMachine") as AnimationNodeStateMachine;
        AnimationNodeBlendSpace2D blendSpace = stateMachine.GetNode("ToolState") as AnimationNodeBlendSpace2D;

        ToolData selectedTool = GetSelectedTool();
        if (libIdx >= selectedTool.AnimationLibraries.Length) { return; }

        // Find the local library name
        string toolLibName = string.Empty;
        foreach (string libName in animationTree.GetAnimationLibraryList())
        {
            AnimationLibrary lib = animationTree.GetAnimationLibrary(libName);
            if (lib == selectedTool.AnimationLibraries[libIdx])
            {
                toolLibName = libName + "/";
                break;
            }
        }

        // Update the blend point animations for each direction
        foreach (string animName in selectedTool.AnimationLibraries[libIdx].GetAnimationList())
        {
            AnimationNodeAnimation animNode = new AnimationNodeAnimation();
            animNode.Animation = toolLibName + animName;
            foreach (string key in _blendPointIdxMap.Keys)
            {
                if (animName.Contains(key))
                {
                    blendSpace.SetBlendPointNode(_blendPointIdxMap[key], animNode);
                }
            }
        }
    }

    private ToolData GetSelectedTool()
    {
        if (IsToolSelected())
        {
            return _toolData[_currentToolIdx];
        }
        return default;
    }

    // Godot signals do not support C# dictionary as a param so manually convert C# dict to Godot dict
    private Godot.Collections.Dictionary GetToolsGodotDict()
    {
        var gdDict = new Godot.Collections.Dictionary();
        foreach (var kvp in _toolData)
            gdDict[kvp.Key] = kvp.Value;
        return gdDict;
    }
    
    private static string VectorToDirection(Vector2 vec)
    {
        if (Mathf.Abs(vec.X) > Mathf.Abs(vec.Y))
            return vec.X > 0 ? "right" : "left";
        else
            return vec.Y > 0 ? "down" : "up";
    }
}

