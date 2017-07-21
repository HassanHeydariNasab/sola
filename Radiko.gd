extends Node2D

onready var FPS = get_node("Kanvaso/FPS")

func _ready():
	set_process(true)

func _process(delta):
	FPS.set_text(str(int(1.0/delta)))

func _on_Iri_pressed():
	Input.action_press("iri")

func _on_Iri_released():
	Input.action_release("iri")

func _on_Turni_dekstre_pressed():
	Input.action_press("turni_dekstre")

func _on_Turni_dekstre_released():
	Input.action_release("turni_dekstre")

func _on_Turni_maldekstre_pressed():
	Input.action_press("turni_maldekstre")

func _on_Turni_maldekstre_released():
	Input.action_release("turni_maldekstre")

func _on_Pafi_pressed():
	Input.action_press("pafi")

func _on_Pafi_released():
	Input.action_release("pafi")
