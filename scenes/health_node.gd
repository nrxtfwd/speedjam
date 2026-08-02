extends Node2D
class_name HealthNode

@export var max_health := 100.0

@onready var base_self := get_parent()
@onready var health := max_health :
		set(value):
				health = min(value,max_health)
				health_changed.emit()
				update_health_bar()
				if health <= 0:
						if base_self.has_signal('died'):
								base_self.died.emit()
						died.emit()
						base_self.queue_free()

var immune = false

signal died
signal health_changed

func update_health_bar():
		pass
		#$bar.value = health/max_health

func hit_flash():
		pass
		#base_self.material.set_shader_parameter('active', true)
		#await get_tree().create_timer(0.1).timeout
		#base_self.material.set_shader_parameter('active', false)

func take_damage(amnt):
		if immune:
				return
		health -= amnt
		hit_flash()
		return true

func _ready() -> void:
		update_health_bar()
