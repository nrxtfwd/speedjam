extends Enemy

@export var robot_can_move := false
@export var rotation_speed := 3.0

func handle_movement(delta):
	var target_vector = Global.player.global_position - global_position
	var target_angle = target_vector.angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	if robot_can_move:
		velocity = global_position.direction_to(
			$target.global_position
			) * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
