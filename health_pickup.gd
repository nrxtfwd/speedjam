extends Area2D


func _on_body_entered(body):
	body.get_node('health_node').health += 0.4*body.get_node('health_node').max_health
	queue_free()
