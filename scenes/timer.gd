extends Label

var time := 0

func _on_timer_timeout():
	time += 1
	var time_str = str(time)
	if len(time_str) <= 1:
		time_str = '0'+time_str
	text = '00:'+time_str
