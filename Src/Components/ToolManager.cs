using System.Collections.Generic;
using System.Linq;
using Godot;

[GlobalClass]
public sealed partial class ToolManager : Node
{
    [Signal]
    public delegate void ToolChangedEventHandler(byte slotIdx);

    [Signal]
    public delegate void ToolBarModifiedEventHandler(ToolData[] toolData);

    [Signal]
    public delegate void ToolUsedEventHandler(byte cooldown, byte SlotIdx);

    private const sbyte NoToolIdx = -1;
    private const int MaxToolSlots = 5;
    private const float ResetCooldownTimeSec = 0.5f;

    [Export]
    private ToolData[] _toolData = System.Array.Empty<ToolData>();

    sbyte _currentToolIdx = NoToolIdx;
    Dictionary<string, byte> _blendPointIdxMap = new Dictionary<string, byte>() { { "left", 0 }, { "right", 0 }, { "up", 0 }, { "down", 0 } };
    Timer _resetCooldownTimer = null;

    public override void _Ready()
    {
        _resetCooldownTimer = new Timer();
        _resetCooldownTimer.WaitTime = ResetCooldownTimeSec;
        _resetCooldownTimer.OneShot = true;
        _resetCooldownTimer.Timeout += OnResetCooldownTimeout;
        AddChild(_resetCooldownTimer);
    }

    public void SetSelectedTool(byte slotIdx, Player player)
    {
        if (slotIdx < MaxToolSlots)
        {
            if (IsToolSelected())
            {
                GetSelectedTool().ResetAnimationLibrariesIdx();
            }
            EmitSignal(nameof(ToolChanged), slotIdx);
        }

        if (slotIdx >= _toolData.Length || slotIdx == _currentToolIdx || _toolData[slotIdx] is null)
        {
            _currentToolIdx = NoToolIdx;
            return;
        }

        if (IsToolSelected())
        {
            GetSelectedTool().OnSwitchIn(player);
        }
        _currentToolIdx = (sbyte)slotIdx;
        GetSelectedTool().OnSwitchOut(player);
        SetToolAnimation(player.AnimationTree);
    }

    public void UseSelectedTool(Player player)
    {
        if (IsToolSelected() && GetSelectedTool().IsCooldownActive) { return; }

        sbyte toolIdx = _currentToolIdx;
        float cooldownSec = GetSelectedTool().ToolCooldownSec;
        GetSelectedTool().IsCooldownActive = true;

        if (GetSelectedTool().AnimationLibraries.Length > 1)
        {
            SetToolAnimation(player.AnimationTree, GetSelectedTool().AnimationLibrariesIdx);
            _resetCooldownTimer.Start(cooldownSec + ResetCooldownTimeSec);
        }
        EmitSignal(nameof(ToolUsed), cooldownSec, _currentToolIdx);
        GetSelectedTool().UseTool(player);
        GetTree().CreateTimer(cooldownSec).Timeout += () => _toolData[toolIdx].IsCooldownActive = false;
    }

    public bool IsToolSelected() { return _currentToolIdx != NoToolIdx; }

    public void RemoveTool(byte slotIdx)
    {
        if (_toolData[slotIdx] is not null)
        {
            _toolData[slotIdx] = null;
        }
        EmitSignal(nameof(ToolBarModified), _toolData);
    }

    public bool AddTool(ToolData toolData)
    {
        if (_toolData.Length >= MaxToolSlots) { return false; }
        _toolData.Append(toolData);
        EmitSignal(nameof(ToolBarModified), _toolData);
        return true;
    }

    public void SwapToolSlots(byte slotIdx1, byte slotIdx2)
    {
        if (_toolData.Length > slotIdx1 && _toolData.Length > slotIdx2)
        {
            (_toolData[slotIdx1], _toolData[slotIdx2]) = (_toolData[slotIdx2], _toolData[slotIdx1]);
            EmitSignal(nameof(ToolBarModified), _toolData);
        }
    }

    public void SetBlendPointIdxMapping(AnimationTree animationTree)
    {
        AnimationNodeBlendTree root = animationTree.TreeRoot as AnimationNodeBlendTree;
        AnimationNodeStateMachine stateMachine = root.GetNode("StateMachine") as AnimationNodeStateMachine;
        AnimationNodeBlendSpace2D blendSpace = stateMachine.GetNode("ToolState") as AnimationNodeBlendSpace2D;

        int blendPointCount = blendSpace.GetBlendPointCount();
        for (int blendSpaceIdx = 0; blendSpaceIdx < blendPointCount; blendSpaceIdx++)
        {
            Vector2 blendPointPos = blendSpace.GetBlendPointPosition(blendSpaceIdx);
            string direction = VectorToDirection(blendPointPos);
            _blendPointIdxMap[direction] = (byte)blendSpaceIdx;
        }
    }

    public void SetToolAnimation(AnimationTree animationTree, byte libIdx = 0)
    {
        AnimationNodeBlendTree root = animationTree.TreeRoot as AnimationNodeBlendTree;
        AnimationNodeStateMachine stateMachine = root.GetNode("StateMachine") as AnimationNodeStateMachine;
        AnimationNodeBlendSpace2D blendSpace = stateMachine.GetNode("ToolState") as AnimationNodeBlendSpace2D;

        var selectedTool = GetSelectedTool();
        if (selectedTool == null)
            throw new System.Exception("Tool not equipped");
        if (libIdx >= selectedTool.AnimationLibraries.Length)
            throw new System.Exception("Invalid animation library index");

        // Find the local library name
        string toolLibName = "";
        foreach (string libName in animationTree.GetAnimationLibraryList())
        {
            var lib = animationTree.GetAnimationLibrary(libName);
            if (lib == selectedTool.AnimationLibraries[libIdx])
            {
                toolLibName = libName + "/";
                break;
            }
        }

        // Update the blend point animations for each direction
        foreach (string animName in selectedTool.AnimationLibraries[libIdx].GetAnimationList())
        {
            var animNode = new AnimationNodeAnimation();
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

    private ToolData GetSelectedTool() { return _toolData[_currentToolIdx]; }

    private void OnResetCooldownTimeout()
    {
        if (IsToolSelected())
        {
            GetSelectedTool().ResetAnimationLibrariesIdx();
        }
    }

    private string VectorToDirection(Vector2 vec)
    {
        if (Mathf.Abs(vec.X) > Mathf.Abs(vec.Y))
            return vec.X > 0 ? "right" : "left";
        else
            return vec.Y > 0 ? "down" : "up";
    }
}