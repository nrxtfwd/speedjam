extends TextureRect

func damaged():
	modulate = Color.WHITE
	var tw = get_tree().create_tween()
	tw.tween_property(
		self,'modulate',Color(1.0, 1.0, 1.0, 0.0),0.3)

func _ready():
	Global.player_damaged.connect(damaged)
