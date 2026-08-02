extends Label

func kills_changed():
	text = '%s Kills' % Global.kills

func _ready():
	kills_changed()
	Global.kills_changed.connect(kills_changed)
