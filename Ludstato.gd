extends Node

var Ludanto = preload("res://Ludanto.tscn")

var ludanto_nomo = ""

var Ludantoj = {}

func _ready():
#	get_tree().connect("network_peer_connected", self, "_player_connected")
#	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_je_konektita_al_servilo")
#	get_tree().connect("connection_failed", self, "_connected_fail")
#	get_tree().connect("server_disconnected", self, "_server_disconnected")
#	mia_Ludanto = get_node("/root/Radiko/"+str(get_tree().get_network_unique_id()))
	set_fixed_process(true)

func malplena_loko():
	var loko = get_node("/root/Radiko/Testilo").get_position()
	get_node("/root/Radiko/Testilo").set_position(Vector2(0,0))
	return loko

func servi(nomo):
	var reto = NetworkedMultiplayerENet.new()
	reto.create_server(7000, 8)
	get_tree().set_network_peer(reto)
	ludanto_nomo = nomo

func aligxi(nomo):
	var reto = NetworkedMultiplayerENet.new()
	reto.create_client("127.0.0.1", 7000)
	get_tree().set_network_peer(reto)
	ludanto_nomo = nomo

# je ludanto
func _je_konektita_al_servilo():
	rpc_id(1, "je_konektita_al_servilo", get_tree().get_network_unique_id(), ludanto_nomo)

# PORFARI kotrolu la procezon je malrapida konekto
# por servilo
remote func je_konektita_al_servilo(id, nomo):
	# se la ludanto estas nova
	if not (nomo in Ludantoj.keys()):
		Ludantoj[nomo] = {
			"id":id, "loko":malplena_loko(), "turno":0, "vivo":20
		}
		# je servilo
		aldoni_la_ludanton(nomo)
		# diru al konektitaj ludantoj ke aldonu la ludanton al sia Ludantoj
		rpc("postglui_novan_ludanton", nomo, Ludantoj[nomo])
	# se la ludanto estas revenita
	else:
		# gxisdatigi mian na id je servilo
		Ludantoj[nomo]["id"] = id
		# gxisdatigi mian na id je klientoj
		rpc("gxisdatigi_na_id", nomo, id)
	rpc_id(id, "preni_Ludantojn", Ludantoj)

# por la ludantoj
remote func postglui_novan_ludanton(nomo, Ludanto):
	Ludantoj[nomo] = Ludanto
	aldoni_la_ludanton(nomo)

# por aliaj ludantoj (kiuj havas gxusta Ludantoj antauxe)
remote func gxisdatigi_na_id(nomo, id):
	# la jxusa konektita ludanto ankoraux ne havas na Ludantoj
	if get_tree().get_network_unique_id() != id:
		Ludantoj[nomo]["id"] = id

# por jxusa konektita ludanto
remote func preni_Ludantojn(servila_Ludantoj):
	Ludantoj = servila_Ludantoj
	aldoni_la_ludantojn()

func aldoni_la_ludanton(nomo):
	var _Ludanto = Ludanto.instance()
	_Ludanto.set_name(nomo)
	_Ludanto.get_node("Id").set_text(nomo)
	_Ludanto.set_network_master(int(Ludantoj[nomo]["id"]))
	_Ludanto.set_position(Ludantoj[nomo]["loko"])
	_Ludanto.set_rotation(Ludantoj[nomo]["turno"])
	_Ludanto.get_node("Vivo").set_scale(Vector2(1,Ludstato.Ludantoj[nomo]["vivo"]/_Ludanto.komenca_vivo))
	get_node("/root/Radiko/Ludantoj").add_child(_Ludanto)

# post sxangxigxado de Ludantoj
func aldoni_la_ludantojn():
	#aldoni ludantojn se ili ne antauxe aldonigxis
	for nomo in Ludantoj.keys():
		if not get_node("/root/Radiko/Ludantoj").has_node(nomo):
			aldoni_la_ludanton(nomo)