extends Node2D

onready var Kugloj = get_tree().get_root().get_node("Radiko/Kugloj")
onready var Malamiko = get_node("Malamiko")
onready var Kuglujo_A = get_node("Malamiko/Aspekto/Kuglujo_A")
onready var Kuglujo_B = get_node("Malamiko/Aspekto/Kuglujo_B")
onready var Resxargigxi = get_node("Resxargigxi")
onready var Vivo = get_node("Malamiko/Aspekto/Vivo")
var Kuglo = preload("res://Kugloj/Kuglo.tscn")

var angulo = 90
var rapido = 10
var vivo = 100
var komenca_vivo = 100.0

var sxargita = true

var pafu = false
var iru = false
var revenu = false
var turnu_dekstre = false
var turnu_maldekstre = false

func _ready():
	set_fixed_process(true)
	set_process(true)

func _fixed_process(delta):
	angulo = Malamiko.get_rot()+deg2rad(90)
	if pafu:
		if sxargita == true:
			var _Kuglo = Kuglo.instance()
			_Kuglo.angulo = angulo
			_Kuglo.set_global_pos(Kuglujo_B.get_global_pos())
			_Kuglo.set_global_rot(angulo)
			Kugloj.add_child(_Kuglo)
			sxargita = false
	if iru:
		Malamiko.move(Vector2(cos(angulo)*rapido, -sin(angulo)*rapido))
	if revenu:
		Malamiko.move(Vector2(-cos(angulo)*rapido, sin(angulo)*rapido))
	if turnu_maldekstre:
		Malamiko.rotate(deg2rad(3))
	elif turnu_dekstre:
		Malamiko.rotate(deg2rad(-3))

func _process(delta):
	Vivo.set_scale(Vector2(vivo/komenca_vivo, 1))
	if vivo <= 0:
		queue_free()

func _on_Resxargigxi_timeout():
	sxargita = true