extends Timer

@export var enemies : Array[PackedScene] = []
@export var snake_part : PackedScene
@export var pickup : PackedScene

var spawn_pickup := 12
var count := 0

func delay_spawn(enemy):
	enemy.process_mode = PROCESS_MODE_DISABLED
	enemy.modulate = Color.DIM_GRAY
	await get_tree().create_timer(1.0).timeout
	enemy.modulate = Color.WHITE
	
	enemy.process_mode = PROCESS_MODE_INHERIT
	

func _on_timeout():
	count += 1
	spawn_pickup -= 1
	if spawn_pickup <= 0:
		spawn_pickup = 12
		var pick = pickup.instantiate()
		pick.global_position = get_children().pick_random().global_position
		Global.scene().add_child(pick)
		return
	if count > 0 and count % 30 == 0:
		stop()
		await get_tree().create_timer(5.0).timeout
		start()
		return
	if get_tree().get_node_count_in_group('enemy') >= 12:
		return
	var base_enemy = enemies.pick_random()
	if randf() <= 0.1:
		base_enemy = snake_part
	var enemy = base_enemy.instantiate()
	enemy.global_position = get_children().pick_random().global_position
	Global.scene().add_child(enemy)
	delay_spawn(enemy)
	var dir = Vector2.RIGHT.rotated(2.0*PI*randf())
	if base_enemy == snake_part:
		var prev = enemy
		for i in range(randi_range(3,4)):
			var seg = base_enemy.instantiate()
			seg.global_position = enemy.global_position + (dir * 9.0 * i)
			Global.scene().add_child(seg)
			seg.connected_to = prev
			delay_spawn(seg)
			prev = seg
