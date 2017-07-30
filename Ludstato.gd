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
	get_node("/root/Radiko/Servilo").queue_free()

func aligxi(nomo):
	var reto = NetworkedMultiplayerENet.new()
	reto.create_client("127.0.0.1", 7000)
	get_tree().set_network_peer(reto)
	ludanto_nomo = nomo
	get_node("/root/Radiko/Kliento").queue_free()

# je ludanto
func _je_konektita_al_servilo():
	rpc_id(1, "je_konektita_al_servilo", get_tree().get_network_unique_id(), ludanto_nomo)

# PORFARI kotrolu la procezon
# por servilo
remote func je_konektita_al_servilo(id, nomo):
	# se mi estas nova ludanto
	if not (nomo in Ludantoj.keys()):
		Ludantoj[nomo] = {
			"id":id, "loko":malplena_loko(), "turno":0, "vivo":20
		}
		aldoni_la_ludantojn()
		# diru al konektitaj ludantoj ke aldonu min al sia Ludantoj
		rpc("postglui_novan_ludanton", nomo, Ludantoj[nomo])
	else:
		# gxisdatigi mian na id je servilo
		Ludantoj[nomo]["id"] = id
		# gxisdatigi mian na id je klientoj
		rpc("gxisdatigi_na_id", nomo, id)
	rpc_id(id, "preni_Ludantojn", Ludantoj)

# por aliaj ludantoj
remote func postglui_novan_ludanton(nomo, Ludanto):
	if get_tree().get_network_unique_id() != Ludanto["id"]:
		Ludantoj[nomo] = Ludanto
		aldoni_la_ludantojn()

# por aliaj ludantoj
remote func gxisdatigi_na_id(nomo, id):
	if get_tree().get_network_unique_id() != id:
		Ludantoj[nomo]["id"] = id

# por jxusa konektita ludanto
remote func preni_Ludantojn(servila_Ludantoj):
	Ludantoj = servila_Ludantoj
	aldoni_la_ludantojn()

# post sxangxigxado de Ludantoj
func aldoni_la_ludantojn():
	#aldoni ludantojn se ili ne antauxe aldonigxis
	for ludanto_nomo in Ludantoj.keys():
		if not get_node("/root/Radiko/Ludantoj").has_node(ludanto_nomo):
			var _Ludanto = Ludanto.instance()
			_Ludanto.set_name(ludanto_nomo)
			_Ludanto.get_node("Id").set_text(ludanto_nomo)
			_Ludanto.set_network_master(int(Ludantoj[ludanto_nomo]["id"]))
			_Ludanto.set_position(Ludantoj[ludanto_nomo]["loko"])
			_Ludanto.set_rotation(Ludantoj[ludanto_nomo]["turno"])
			_Ludanto.get_node("Vivo").set_scale(Vector2(1,Ludstato.Ludantoj[ludanto_nomo]["vivo"]/_Ludanto.komenca_vivo))
			get_node("/root/Radiko/Ludantoj").add_child(_Ludanto)