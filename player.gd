extends CharacterBody2D

@export var speed := 200.0
@export var accel := 30.0

var dash = false
var dash_ifr = false
var dash_cd = false
var last_dash := 0.0
var dash_vel : Vector2

func _ready():
	Global.player = self

func handle_dash():
	if Input.is_action_pressed('dash'):
		if dash_cd or dash:
			return
		dash_ifr = true
		dash = true
		dash_vel = global_position.direction_to(
			get_global_mouse_position()
		) * speed*2.5
		set_collision_mask_value(2,false)
		#modulate = Color(1.0, 1.0, 1.0, 0.467)
		%dash.emitting = true
		await get_tree().create_timer(0.05).timeout
		dash = false
		dash_cd = true
		
		await get_tree().create_timer(0.1).timeout
		dash_ifr = false
		%dash.emitting = false
		set_collision_mask_value(2,true)
		#modulate = Color.WHITE
		await get_tree().create_timer(0.13).timeout
		dash_cd = false
		

func freeze():
	pass

func _physics_process(delta):
	if dash:
		velocity = dash_vel
	else:
		velocity = velocity.move_toward(
			Input.get_vector(
				'left','right','up','down'
			)*speed,accel
		)
	$body.look_at(global_position+velocity)
	$arrow.look_at(get_global_mouse_position())
	$arrow.rotation+=PI/2.0
	handle_dash()
	move_and_slide()

func _on_hitbox_body_entered(body):
	body.damaged()
	Global.damage(self,body,5.0)

func _on_timer_timeout():
	Engine.time_scale = 1.0
