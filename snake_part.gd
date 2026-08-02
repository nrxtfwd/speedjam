extends Enemy
class_name SnakePart

@export var follow_distance := 16.0

var connected_to
var position_history : Array[Vector2] = []

func _physics_process(delta):
	position_history.append(global_position)
	if position_history.size() > 100:
		position_history.pop_front()

	if attack_timer > 0.0:
		attack_timer -= delta

	if not connected_to:
		velocity = global_position.direction_to(Global.player.global_position) * speed
		look_at(global_position + velocity)
		move_and_slide()
	else:
		var target_pos = connected_to.get_target_position_at_distance(follow_distance)
		velocity = global_position.direction_to(target_pos) * speed
		
		if global_position.distance_to(target_pos) > 2.0:
			look_at(target_pos)
			move_and_slide()
		else:
			velocity = Vector2.ZERO

	_check_player_damage()

func get_target_position_at_distance(target_dist: float) -> Vector2:
	var accumulated_dist := 0.0
	var prev_point := global_position
	
	for i in range(position_history.size() - 1, -1, -1):
		var pt = position_history[i]
		accumulated_dist += prev_point.distance_to(pt)
		if accumulated_dist >= target_dist:
			return pt
		prev_point = pt
		
	return position_history.front() if not position_history.is_empty() else global_position
