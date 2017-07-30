extends KinematicBody2D

var tipo = "ludanto"

onready var Kuglo = preload("res://Kugloj/Kuglo.tscn")

onready var Kuglujo = get_node("Kuglujo")
onready var Vivo = get_node("Vivo")

var rapido = 10
var d_angulo = deg2rad(3)
var komenca_vivo = 20.0

var resxargxita = true

func _ready():
	set_process(true)

func _process(delta):
	#se mi estas posedanto
	if is_network_master():
		if Input.is_action_pressed("iri"):
			rpc_id(1, "movi", 1)
			move(Vector2(rapido*cos(get_rotation()), rapido*sin(get_rotation())))
		if Input.is_action_pressed("reveni"):
			rpc_id(1, "movi", -1)
			move(Vector2(-rapido*cos(get_rotation()), -rapido*sin(get_rotation())))
		if Input.is_action_pressed("turni_dekstre"):
			rpc_id(1, "turni", 1)
			rotate(d_angulo)
		if Input.is_action_pressed("turni_maldekstre"):
			rpc_id(1, "turni", -1)
			rotate(-d_angulo)
		if Input.is_action_pressed("pafi"):
			if resxargxita:
				# VUNDEBLA
				resxargxita = false
				# la pafo vidigxas cxie (sed nur ni konfidos gxin en servilo)
				rpc("pafi")

# por servilo
remote func movi(flanko):
	var nuna_turno = Ludstato.Ludantoj[get_name()]["turno"]
	move(Vector2(flanko*rapido*cos(nuna_turno),
				 flanko*rapido*sin(nuna_turno))
		)
	Ludstato.Ludantoj[get_name()]["loko"] = get_global_position()
	rpc("gxisdatigi_lokon", get_global_position())

# por ludantoj
remote func gxisdatigi_lokon(loko):
	Ludstato.Ludantoj[get_name()]["loko"] = loko
	if not is_network_master():
		set_global_position(loko)

# por servilo
remote func turni(flanko):
	rotate(d_angulo*flanko)
	Ludstato.Ludantoj[get_name()]["turno"] = get_rotation()
	rpc("gxisdatigi_turnon", get_rotation())

# por ludantoj
remote func gxisdatigi_turnon(turno):
	Ludstato.Ludantoj[get_name()]["turno"] = turno
	if not is_network_master():
		set_rotation(turno)

sync func pafi():
	var _Kuglo = Kuglo.instance()
	_Kuglo.set_global_position(Kuglujo.get_global_position())
	_Kuglo.set_rotation(get_rotation())
	_Kuglo.angulo = get_rotation()
	get_tree().get_root().get_node("/root/Radiko/Kugloj").add_child(_Kuglo)

# por ludantoj
remote func gxisdatigi_vivon(valoro):
	Ludstato.Ludantoj[get_name()]["vivo"] += valoro
	Vivo.set_scale(Vector2(1,Ludstato.Ludantoj[get_name()]["vivo"]/komenca_vivo))

# por ludantoj
remote func forigi_la_ludanton():
	Ludstato.Ludantoj.erase(get_name())
	get_node("/root/Radiko/Ludantoj/"+get_name()).queue_free()

func _on_Resxargxo_timeout():
	resxargxita = true