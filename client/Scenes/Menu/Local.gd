extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var username : String = $"/root/GameManager".player_data.username
	var rank = 0
	for score in $"/root/GameManager".local_scores:
		rank += 1
		var time : float = score
		var minutes : int = time / 60
		var seconds : int = time - minutes*60
		var cents : int = int(100.0*time)%100
		self.add_item("#%03d %-50s %02d:%02d.%02d" % [rank, username, minutes,seconds,cents])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
