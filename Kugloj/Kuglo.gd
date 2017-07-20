extends Node2D

var angulo = 0.1

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	set_pos(get_pos()+Vector2(15*cos(angulo), 15*-sin(angulo)))
