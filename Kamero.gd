extends Camera2D

onready var Sola = get_tree().get_root().get_node("Radiko/Sola/Sola")

func _ready():
	set_process(true)

func _process(delta):
	set_offset(Sola.get_global_pos())