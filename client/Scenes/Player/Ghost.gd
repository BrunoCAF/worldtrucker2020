extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_data(x : float, y : float, theta : float, cargo : float):
	self.global_position.x = x
	self.global_position.y = y
	self.global_rotation = theta
	$Sprite.global_rotation = cargo
