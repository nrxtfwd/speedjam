extends CharacterBody2D
class_name Enemy

const ENEMY_DEATH = preload("uid://c44hm5qgnr20y")

@export var speed := 20.0
@export var damage_amount := 1.0
@export var base_damage_radius := 8.0
@export var attack_cooldown := 1.0
@export var base_half_size := Vector2(8.0, 8.0)

var damaged_tw : Tween
var attack_timer := 0.0

func died():
	Global.kills += 1
	var enemy_death = ENEMY_DEATH.instantiate()
	enemy_death.global_position = global_position
	enemy_death.emitting = true
	Global.scene().add_child(enemy_death)

func _ready():
	add_to_group('enemy')
	$health_node.died.connect(died)

func _physics_process(delta):
	if attack_timer > 0.0:
		attack_timer -= delta
	velocity = global_position.direction_to(
			Global.player.global_position
		) * speed
	look_at(global_position+velocity)
	move_and_slide()
	
	_check_player_damage()

func _check_player_damage():
	if not Global.player or attack_timer > 0.0:
		return
	if Global.player.dash_ifr:
		return
		
	var my_half = base_half_size * scale
	var player_half = base_half_size * Global.player.scale
	
	var diff = (global_position - Global.player.global_position).abs()
	var max_touch_distance = my_half + player_half
	
	if diff.x <= max_touch_distance.x and diff.y <= max_touch_distance.y:
		if Global.player.has_method("take_damage"):
			Global.player.take_damage(damage_amount)
		elif Global.player.has_node("health_node"):
			Global.player.get_node("health_node").take_damage(damage_amount)
		Global.player.freeze()
		Global.player_damaged.emit()
		attack_timer = attack_cooldown

func damaged():
	if damaged_tw:
		damaged_tw.kill()
	scale = Vector2.ONE * 1.1
	damaged_tw = get_tree().create_tween()
	damaged_tw.set_parallel(true)
	damaged_tw.set_trans(Tween.TRANS_BACK)
	for child in get_children():
		if child is Sprite2D:
			var color = child.modulate
			child.modulate = Color.WHITE
			damaged_tw.tween_property(
				child,'modulate',color,0.2
			)
	damaged_tw.tween_property(self,'scale',Vector2.ONE,0.2)
