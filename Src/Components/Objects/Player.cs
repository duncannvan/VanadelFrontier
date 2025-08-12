using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using Godot;

[GlobalClass]
public partial class Player : CharacterBody2D, IHittable
{
    /*
        Static Fields
    */
    private static readonly ImmutableDictionary<string, IHittable.States> _states = ImmutableDictionary.CreateRange(new[]
    {
        new KeyValuePair<string, IHittable.States>("MoveState", IHittable.States.MOVE),
        new KeyValuePair<string, IHittable.States>("ToolState", IHittable.States.TOOL),
        new KeyValuePair<string, IHittable.States>("KnockbackState", IHittable.States.KNOCKBACK),
        new KeyValuePair<string, IHittable.States>("DeadState", IHittable.States.DEAD),
    });

    /*
        Instance Fields
    */
    private Vector2 _lastFacingDirection = Vector2.Down;
    private AnimationNodeStateMachinePlayback _animationStateMachine;

    /*
        Properties
    */
    public StatsComponent StatsComponent { get; private set; }
    public Hitbox Hitbox { get; private set; }
    public AnimationPlayer EffectAnimations { get; private set; }
    public ToolManager ToolManager { get; private set; }
    public InventoryManager InventoryManager { get; private set; }
    public AnimationTree AnimationTree { get; private set; }

    /*
        Internal Godot Methods
    */
    public override void _Ready()
    {
        StatsComponent = GetNode<StatsComponent>("StatsComponent");
        Hitbox = GetNode<Hitbox>("ToolPivot/Hitbox");
        EffectAnimations = GetNode<AnimationPlayer>("EffectsPlayer");
        ToolManager = GetNode<ToolManager>("ToolManager");
        InventoryManager = GetNode<InventoryManager>("InventoryManager");
        AnimationTree = GetNode<AnimationTree>("AnimationTree");

        _animationStateMachine = AnimationTree.Get("parameters/StateMachine/playback").As<AnimationNodeStateMachinePlayback>();

        StatsComponent.Died += OnDied;
        ToolManager.SetBlendPointIdxMapping(AnimationTree);
    }
    
    public override void _PhysicsProcess(double delta)
    {
        string currentStateStr = _animationStateMachine.GetCurrentNode();

        switch (_states[currentStateStr])
        {
            case IHittable.States.MOVE:
                HandleMovement();
                break;
            case IHittable.States.KNOCKBACK:
                Velocity = StatsComponent.GetKnockbackVector();
                MoveAndSlide();
                break;
            default:
                break;
        }
    }

    /*
        Public Methods
    */
    public void SetState(IHittable.States newState)
    {
        if (GetStateName(newState) != _animationStateMachine.GetCurrentNode())
        {
            _animationStateMachine.Travel(GetStateName(newState));
        }
    }
    

    /*
        Private Methods
    */
    private void HandleMovement()
    {
        Vector2 moveDirection = Input.GetVector("move_left", "move_right", "move_up", "move_down");

        if (moveDirection != Vector2.Zero)
        {
            _lastFacingDirection = moveDirection;
            UpdateBlendPositions(moveDirection);
        }

        if (Input.IsActionJustPressed("use_tool") && ToolManager.IsToolSelected())
        {
            ToolManager.UseSelectedTool(this);
        }

        Velocity = moveDirection * StatsComponent.GetCurrentSpeed();
        MoveAndSlide();
    }

    private void OnDied()
    {
        SetState(IHittable.States.DEAD);
        QueueFree();
    }

    private void UpdateBlendPositions(Vector2 direction)
    {
        string[] paths = [
            "parameters/StateMachine/MoveState/Idle/blend_position",
            "parameters/StateMachine/MoveState/Running/blend_position",
            "parameters/StateMachine/ToolState/blend_position",
            "parameters/StateMachine/KnockbackState/blend_position"
        ];

        for (byte pathsIdx = 0; pathsIdx < paths.Length; pathsIdx++)
        {
            _animationStateMachine.Set(paths[pathsIdx], direction);
        }
    }

    private string GetStateName(IHittable.States stateKey)
    {
        return _states.FirstOrDefault(keyValuePair => keyValuePair.Value == stateKey).Key;
    }
}