extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var current : Label = $"PanelContainer/VBoxContainer2/VBoxContainer/HBoxContainer4/Time"
onready var best_local : Label = $"PanelContainer/VBoxContainer2/VBoxContainer/HBoxContainer5/Time"
onready var best_online : Label = $"PanelContainer/VBoxContainer2/VBoxContainer/HBoxContainer6/Time"

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/GameManager".add_score()
	print("added score")
	current.text = get_time_string($"/root/GameManager".current_score)
	best_local.text = get_time_string($"/root/GameManager".local_scores[0])
	if $"/root/GameManager".best_score > 0:
		best_online.text = get_time_string($"/root/GameManager".best_score)
		if $"/root/GameManager".best_score < $"/root/GameManager".current_score:
			$"PanelContainer/VBoxContainer2/VBoxContainer/SubmitButton".disabled = true
	else:
		best_online.text = "NONE"
		$"PanelContainer/VBoxContainer2/VBoxContainer/SubmitButton".disabled = false
	if $"/root/GameManager".player_data.uuid == "null":
		$"PanelContainer/VBoxContainer2/VBoxContainer/SubmitButton".disabled = true
	pass # Replace with function body.

func get_time_string(time : float) -> String :
	var minutes : int = time / 60
	var seconds : int = time - minutes*60
	var cents : int = int(100.0*time)%100
	return "%02d:%02d.%02d"%[minutes, seconds, cents]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SubmitButton_pressed():
	$"PanelContainer/VBoxContainer2/VBoxContainer/EXIT".disabled = true
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "on_submited")
	$"PanelContainer/VBoxContainer2/VBoxContainer/Status".text = "SUBMITING..."
	var data = {
		"username" : $"/root/GameManager".player_data.username,
		"userid" : $"/root/GameManager".player_data.uuid,
		"conclusionTime" : $"/root/GameManager".current_score,
		"ghostInfo" : $"/root/GameManager".current_ghost_data,
	}
	print(to_json(data))
	var error = http_request.request("https://worldtrucker2020.herokuapp.com/submit", ["Cache-Control: no-cache"], true, HTTPClient.METHOD_POST, to_json(data))
	if error != OK:
		$"PanelContainer/VBoxContainer2/VBoxContainer/Status".text = "FAILED"
	pass # Replace with function body.

func on_submited(result, response_code, headers, body):
	print(body.get_string_from_utf8())
	print(response_code)
	if response_code == 200:
		$"/root/GameManager".best_score = $"/root/GameManager".current_score
		$"/root/GameManager".save_scores()
	$"PanelContainer/VBoxContainer2/VBoxContainer/EXIT".disabled = false
	$"PanelContainer/VBoxContainer2/VBoxContainer/Status".text = "DONE"
	$"PanelContainer/VBoxContainer2/VBoxContainer/SubmitButton".disabled = true
	pass


func _on_EXIT_pressed():
	$"/root/GameManager".go_to_menu()
	pass # Replace with function body.
