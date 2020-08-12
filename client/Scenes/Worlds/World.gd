extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var elapsed_time = 0.0
var bar_width = 32
var current_map = 1
var player = null
var maps = []

onready var ghost = $"/root/GameManager".GhostData
onready var score = $"/root/GameManager".Score
# Called when the node enters the scene tree for the first time.
func _ready():
	load_maps()
	setup_map(current_map)

func load_maps():
	while true:
		var map = load("res://Scenes/Worlds/World1/Map" + String(maps.size() + 1) + ".tscn")
		if not map:
			break
		maps.push_back(map)
	print("loaded " + String(maps.size()) + " maps")

func setup_screens():
	$WinScreen.position = -get_viewport_rect().size + Vector2(0,bar_width)
	$LoseScreen.position = -get_viewport_rect().size
	$LoseScreen.position.y *= -1
	$LoseScreen.position.y += -bar_width

func setup_map(num : int):
	setup_screens()
	if player != null:
		player.free()
	
	var player_packed : PackedScene = load("res://Scenes/Player/Player.tscn")
	
	var map = maps[current_map - 1].instance()
	player = player_packed.instance()
	
	for child in $Map.get_children():
		child.free()
	
	$Map.add_child(map)
	$Map.add_child(player)
	player.global_transform = map.get_node("PlayerSpawn").global_transform
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	$WinScreen.position.x = clamp(player.progress - 1, -1, 0)*get_viewport_rect().size.x
	$LoseScreen.position.x = clamp(player.damage - 1, -1, 0)*get_viewport_rect().size.x
	if Input.is_action_pressed("player_reset"):
		self.setup_map(current_map)
	
	if player.progress >= 1:
		current_map += 1
		if current_map > maps.size():
			$"/root/GameManager".end_game()
		else:
			self.setup_map(current_map)
