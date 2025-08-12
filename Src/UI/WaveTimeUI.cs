// using Godot;

// public partial class WaveTimer : Control
// {
// 	public Timer _timer = null;

// 	[Export]
// 	private Label _label = null;

// 	[Export]
// 	private Button _nextWaveButton;

// 	public override void _Ready()
// 	{
// 		_nextWaveButton.ButtonDown += OnButtonPressed;
// 	}

// 	public override void _Process(double delta)
// 	{
// 		if (_timer.IsStopped()) { return; }

// 		_label.Text = $"{(uint)_timer.TimeLeft} Seconds before the next wave";
// 	}

// 	public void StartCountdown(Timer waveCountdownTimer)
// 	{
// 		Visible = true;
// 		_timer = waveCountdownTimer;
// 		_timer.Timeout += () => { Visible = false; };
// 	}

// 	private void OnButtonPressed()
// 	{
// 		_timer?.Stop();
// 		_timer?.EmitSignal("timeout");
// 	}
// }
