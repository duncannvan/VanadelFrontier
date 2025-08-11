using Godot;

public sealed partial class PlayerCamera : Camera2D
{
	[Export]
	public float RandomStrength = 5.0f;

	[Export]
	public float ShakeFade = 10.0f;

	private float _shakeStrength = 0.0f;
	private RandomNumberGenerator _rng = new RandomNumberGenerator();

	public void ShakeCamera()
	{
		_shakeStrength = RandomStrength;
	}

	public override void _Process(double delta)
	{
		if (_shakeStrength > 0)
			_shakeStrength = Mathf.Lerp(_shakeStrength, 0, (float)(ShakeFade * delta));

		Offset = RandomOffset();
	}

	private Vector2 RandomOffset()
	{
		return new Vector2(
			_rng.RandfRange(-_shakeStrength, _shakeStrength),
			_rng.RandfRange(-_shakeStrength, _shakeStrength)
		);
	}
}
