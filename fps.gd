extends Label

func _process(delta):
	text = '%s FPS' % int(Engine.get_frames_per_second())
