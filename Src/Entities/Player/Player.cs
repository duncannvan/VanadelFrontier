using System.Collections.Generic;
using Godot;

[GlobalClass]
public partial class Player : CharacterBody2D, IHittable
{
    private readonly Dictionary<string, IHittable.States> _states = new Dictionary<string, IHittable.States>
    {
        { "MoveState", IHittable.States.MOVE },
        { "ToolState", IHittable.States.TOOL },
        { "KnockbackState", IHittable.States.KNOCKEDBACK },
        { "DeadState", IHittable.States.DEAD },
    };

    private Vector2 _lastFacingDirection = Vector2.Down;

    public StatsComponent StatsComponent { get; private set; }
    public Hurtbox Hurtbox { get; private set; }
    public Hitbox Hitbox { get; private set; }
    public AnimationPlayer EffectsPlayer { get; private set; }
    public ToolManager ToolManager { get; private set; }
    public InventoryManager InventoryManager { get; private set; }
    public AnimationTree AnimationTree { get; private set; }

//    // private Camera2D _playerCamera;
    private AnimationNodeStateMachinePlayback _animationStateMachine;

    public override void _Ready()
    {
        Hurtbox = GetNode<Hurtbox>("Hurtbox");
        Hitbox = GetNode<Hitbox>("ToolPivot/Hitbox");
        StatsComponent = GetNode<StatsComponent>("StatsComponent");
        EffectsPlayer = GetNode<AnimationPlayer>("EffectsPlayer");

        //_playerCamera = GetNode<Camera2D>("Camera2D");
        AnimationTree = GetNode<AnimationTree>("AnimationTree");
        _animationStateMachine = AnimationTree.Get("parameters/StateMachine/playback").As<AnimationNodeStateMachinePlayback>();
        ToolManager = GetNode<ToolManager>("ToolManager");
        InventoryManager = GetNode<InventoryManager>("InventoryManager");

        Hurtbox.HurtboxEntered += OnHurtboxEntered;
        StatsComponent.Died += OnDied;
        ToolManager.SetBlendPointIdxMapping(AnimationTree);
    }
    
    public void SetState(IHittable.States newState)
    {
        if (GetStateName(newState) != _animationStateMachine.GetCurrentNode())
        {
            _animationStateMachine.Travel(GetStateName(newState));
        }
    }
    
    private void physicsProcessMovement(float delta)
    {
        string currentStateStr = _animationStateMachine.GetCurrentNode();

        if (!_states.ContainsKey(currentStateStr)) { return; }

        switch (_states[currentStateStr])
        {
            case IHittable.States.MOVE:
                HandleMovement();
                break;
            case IHittable.States.KNOCKEDBACK:
                Velocity = StatsComponent.GetKnockbackVector();
                MoveAndSlide();
                break;
            default:
                break;
        }
    }

    private void HandleMovement()
    {
        Vector2 inputVector = Input.GetVector("move_left", "move_right", "move_up", "move_down");

        if (inputVector != Vector2.Zero)
        {
            _lastFacingDirection = inputVector;
            UpdateBlendPositions(inputVector);
        }

        if (Input.IsActionJustPressed("use_tool"))
        {
            if (ToolManager.IsToolSelected())
            {
                ToolManager.UseSelectedTool(this);
            }
        }
    }

    private void OnHurtboxEntered(Hitbox hitbox)
    {
        foreach (HitEffect effect in hitbox.HitEffects)
        {
            effect.ApplyEffect(this, hitbox.GlobalPosition);
        }
    }

    private void OnDied(){ }

    private void UpdateBlendPositions(Vector2 direction)
    {
        AnimationTree.Set("parameters/StateMachine/MoveState/Idle/blend_position", direction);
        AnimationTree.Set("parameters/StateMachine/MoveState/Running/blend_position", direction);
        AnimationTree.Set("parameters/StateMachine/ToolState/blend_position", direction);
        AnimationTree.Set("parameters/StateMachine/KnockbackState/blend_position", direction);
    }

    private string GetStateName(IHittable.States stateKey)
    {
        foreach (var state in _states)
        {
            if (state.Value == stateKey)
            {
                return state.Key;
            }
        }
        return null;
    }
}