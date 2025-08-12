using Godot;
using System.Collections.Generic;

public partial class NatureSpawner : Node2D
{
    private Queue<Vector2> positionQueue = new Queue<Vector2>();

    public override void _Ready()
    {
        foreach (var child in GetChildren())
        {
            if (child is Harvestable natureObject)
            {
                natureObject.Died += HandleRespawn;
            }
        }
    }

    public async void HandleRespawn(Harvestable obj)
    {
        positionQueue.Enqueue(obj.GlobalPosition);

        var newObj = obj.CreateScene();
        obj.QueueFree();
        await ToSignal(GetTree().CreateTimer(newObj.RespawnTimeSec), "timeout");

        newObj.GlobalPosition = positionQueue.Dequeue();
        AddChild(newObj);
    }
}