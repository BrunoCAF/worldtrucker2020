extends Node

var player_data_filename : String = "user://player_data.save"

const save_version : String = "0.1.1"
class PlayerData:
	var cabin_color : String = Color.white.to_html()
	var cargo_color : String = Color.white.to_html()
	var username : String = "Unknown Player"
	var version : String = save_version

class GhostInfo:
	var x : Array = []
	var y : Array = []
	var rotation : Array = []
	var cargo_rotation : Array = []

class GhostData:
	var ghosts : Array = []

class Score:
	var username : String
	var time : float

class Scores:
	var scores : Array = []
	func get_ghost(position: int) -> GhostData:
		return null

class LocalScores:
	extends Scores
	var ghosts : Array = []
	func get_ghost(position: int) -> GhostData:
		return ghosts[position]
	
var player_data : PlayerData = PlayerData.new()

var score_field = {
	"username" : null,
	"conclusionTime" : null,
	"ghostInfo" : null
}

onready var world = load("res://Scenes/Worlds/World.tscn")
onready var menu = load("res://Scenes/Menu/Menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	pass # Replace with function body.

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
	get_tree().change_scene_to(menu)
	var scores = []
