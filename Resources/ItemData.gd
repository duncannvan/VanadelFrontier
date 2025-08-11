using Godot;

[GlobalClass]
public partial class ItemData : Resource
{
	[Export]
	public string Name { get; set; } = "";

	[Export]
	private Texture2D _texture = null;

	public Texture2D Texture
	{
		get
		{
			if (_texture == null)
				throw new System.Exception("Attempt to retrieve null");
			return _texture;
		}
		set
		{
			_texture = value;
		}
	}
}
