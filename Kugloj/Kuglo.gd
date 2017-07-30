extends Area2D

onready var Tempilo = get_node("Tempilo")
var Korpo

var angulo = 0
var rapido = 30
var potenco = 1

func _ready():
	set_process(true)

func _process(delta):
	position += Vector2(rapido*cos(angulo), rapido*sin(angulo))

func _on_Tempilo_timeout():
	queue_free()

func _on_Kuglo_body_entered( korpo ):
	queue_free()
	if get_tree().is_network_server():
		if korpo.tipo == "ludanto":
			if Ludstato.Ludantoj.has(korpo.get_name()):
				Ludstato.Ludantoj[korpo.get_name()]["vivo"] -= potenco
				korpo.get_node("Vivo").set_scale(Vector2(1,Ludstato.Ludantoj[korpo.get_name()]["vivo"]/korpo.komenca_vivo))
				korpo.rpc("gxisdatigi_vivon", -potenco)
				if Ludstato.Ludantoj[korpo.get_name()]["vivo"] <= 0:
					Ludstato.Ludantoj.erase(korpo.get_name())
					korpo.rpc("forigi_la_ludanton")
					korpo.queue_free()
