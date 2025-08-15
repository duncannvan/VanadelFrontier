using Godot;

[GlobalClass]
public partial class WaveCountdown : Control
{

	[Signal]
	public delegate void StartWaveEventHandler();

	private Timer _countDownTimer = null;

	[Export]
	private Label _label = null;

	[Export]
	private Button _nextWaveButton;

	public override void _Ready()
	{
		_nextWaveButton.ButtonDown += OnButtonPressed;

		_countDownTimer = new Timer();
		_countDownTimer.OneShot = true;
		_countDownTimer.Timeout += () =>
		{
			Visible = false;
			EmitSignal(nameof(StartWave));
		};

		AddChild(_countDownTimer);
	}

	public override void _Process(double delta)
	{
		if (_countDownTimer.IsStopped()) { return; }

		_label.Text = $"{(ushort)_countDownTimer.TimeLeft} Seconds before the next wave";
	}

	public void StartCountdown(uint wavePeriod)
	{
		Visible = true;
		_countDownTimer.Start(wavePeriod);
	}

	private void OnButtonPressed()
	{
		_countDownTimer.Stop();
		Visible = false;
		EmitSignal(nameof(StartWave));
	}
}
