extends Node2D

onready var Nomo = get_node("Nomo")
onready var Testilo = get_node("Testilo")

func _ready():
	pass

func _on_Servilo_pressed():
	Ludstato.servi(Nomo.get_text())

func _on_Kliento_pressed():
	Ludstato.aligxi(Nomo.get_text())

func _on_Testilo_body_entered( korpo ):
	if korpo.tipo == "ludanto":
		Testilo.position.x += 200

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