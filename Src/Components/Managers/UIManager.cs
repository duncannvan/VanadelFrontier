using Godot;

[GlobalClass]
public sealed partial class UIManager : Node
{
    [Export]
    private ToolBar _toolbarUI;

    public void Init(Player player)
    {
        player.ToolManager.ToolSelectionChanged += _toolbarUI.UpdateSelectedTool;
        player.ToolManager.ToolBarModified += _toolbarUI.RefreshToolbar;
        player.ToolManager.ToolUsed += _toolbarUI.StartCooldown;
        _toolbarUI.ToolSlotClicked += _toolbarUI.UpdateSelectedTool;
        // _toolbarUI.refresh_toolbar(_tool_manager.get_all_tools)
    }

}