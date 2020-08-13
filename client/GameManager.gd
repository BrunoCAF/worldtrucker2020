extends Node

var player_data_filename : String = "user://player_data.save"
var local_score_filename : String = "user://local_score.save"

const save_version : String = "0.2.0"
class PlayerData:
	var cabin_color : String = Color.white.to_html()
	var cargo_color : String = Color.white.to_html()
	var username : String = "Unknown Player"
	var version : String = save_version
	var uuid : String = "null"

class GhostInfo:
	var x : Array = []
	var y : Array = []
	var rotation : Array = []
	var cargo_rotation : Array = []

class GhostData:
	var ghosts : Array = []

class Scores:
	var scores : Array = []
	
var player_data : PlayerData = PlayerData.new()
var local_scores : Array = []
var current_ghost_data : GhostData = GhostData.new()
var current_score : float = 0.0
var best_score : float = -1.0
var ghost_data : GhostData = null

onready var world = load("res://Scenes/Worlds/World.tscn")
onready var menu = load("res://Scenes/Menu/Menu.tscn")
onready var end_screen = load("res://Scenes/EndScreen/EndScreen.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	load_scores()
	print(local_scores)
	check_uuid()
	pass # Replace with function body.

func load_scores():
	var file = File.new()
	if not file.file_exists(local_score_filename):
		save_scores()
		return
	file.open(local_score_filename, File.READ)
	best_score = file.get_var(true)
	while true:
		var score = file.get_var(true)
		if score:
			self.local_scores.push_back(score)
		else:
			return

func save_scores():
	var file = File.new()
	file.open(local_score_filename, File.WRITE)
	file.store_var(best_score)
	for score in local_scores:
		file.store_var(score, true)

func add_score():
	local_scores.push_back(current_score)
	local_scores.sort()
	if local_scores.size() > 10:
		local_scores.pop_back()
	save_scores()
	pass

func check_uuid():
	if self.player_data.uuid != "null":
		return
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "set_uuid")
	
	var error = http_request.request("https://worldtrucker2020.herokuapp.com/newuuid", ["Cache-Control: no-cache"])
	if error != OK:
		push_error("Unable to get UUID from server, maybe a connection problem?")
	
func set_uuid(result, response_code, headers, body):
	self.player_data.uuid = body.get_string_from_utf8()
	print("got new UUID from server")
	save_data()

func load_data():
	var file = File.new()
	if not file.file_exists(player_data_filename):
		save_data()
		return
	file.open(player_data_filename, File.READ)
	var line = file.get_line()
	if not validate_json(line):
		var parsed = parse_json(line)
		if not parsed.has("version") or parsed["version"] != save_version:
			save_data()
			return
		self.player_data = dict2inst(parsed)
		if not self.player_data:
			self.player_data = PlayerData.new()
			save_data()
	else:
		self.player_data = PlayerData.new()
		save_data()
	
	print("data loaded:" + line)

func save_data():
	var file = File.new()
	file.open(player_data_filename, File.WRITE)
	file.store_line(to_json(inst2dict(player_data)))
	

func start_game():
	get_tree().change_scene_to(world)

func end_game():
	get_tree().change_scene_to(end_screen)

func go_to_menu():
	get_tree().change_scene_to(menu)
	current_score = 0.0
	current_ghost_data = GhostData.new()
	ghost_data = null
