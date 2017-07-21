extends Node2D

onready var Kugloj = get_tree().get_root().get_node("Radiko/Kugloj")
onready var Sola = get_node("Sola")
onready var Kuglujo_A = get_node("Sola/Aspekto/Kuglujo_A")
onready var Kuglujo_B = get_node("Sola/Aspekto/Kuglujo_B")
onready var Resxargigxi = get_node("Resxargigxi")
onready var Vivo = get_node("Sola/Aspekto/Vivo")
var Kuglo = preload("res://Kugloj/Kuglo.tscn")

var angulo = 90
var rapido = 10
var vivo = 100
var komenca_vivo = 100.0

var sxargita = true

func _ready():
	set_fixed_process(true)
	set_process(true)

func _fixed_process(delta):
	angulo = Sola.get_rot()+deg2rad(90)
	if Input.is_action_pressed("pafi"):
		if sxargita == true:
			var _Kuglo = Kuglo.instance()
			_Kuglo.angulo = angulo
			_Kuglo.set_global_pos(Kuglujo_B.get_global_pos())
			_Kuglo.set_global_rot(angulo)
			Kugloj.add_child(_Kuglo)
			sxargita = false
	if Input.is_action_pressed("iri"):
		Sola.move(Vector2(cos(angulo)*rapido, -sin(angulo)*rapido))
	if Input.is_action_pressed("reveni"):
		Sola.move(Vector2(-cos(angulo)*rapido, sin(angulo)*rapido))
	if Input.is_action_pressed("turni_maldekstre"):
		Sola.rotate(deg2rad(3))
	elif Input.is_action_pressed("turni_dekstre"):
		Sola.rotate(deg2rad(-3))

func _process(delta):
	Vivo.set_scale(Vector2(vivo/komenca_vivo, 1))

func _on_Resxargigxi_timeout():
	sxargita = true