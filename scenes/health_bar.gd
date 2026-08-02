extends ProgressBar

@onready var hn : HealthNode = Global.player.get_node('health_node')

func health_changed():
	value = hn.health/hn.max_health
	$Label.text = str(int(hn.health))+'/'+str(int(hn.max_health))

func _ready():
	health_changed()
	hn.health_changed.connect(health_changed)
