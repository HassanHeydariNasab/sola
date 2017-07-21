extends Node2D

var angulo = 0.1

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	set_pos(get_pos()+Vector2(20*cos(angulo), 20*-sin(angulo)))


func _on_Vivo_timeout():
	queue_free()


func _on_Areo_body_enter( korpo ):
	if korpo.get_name() == "Malamiko":
		korpo.get_parent().vivo -= 10
	queue_free()
