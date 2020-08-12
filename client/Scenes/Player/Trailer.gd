extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var wheel_friction = 10

export var win_time = 2.0
onready var current_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$container.modulate = $"/root/GameManager".player_data["cargo_color"]
	pass # Replace with function body.

func _physics_process(delta):
	var offset = $Wheels.global_position - self.global_position
	var wheel_speed = self.linear_velocity + self.angular_velocity*offset.rotated(PI/2)
	var lateral_wheel_speed = wheel_speed.project($Wheels.global_transform.x)
	self.apply_impulse(offset, -wheel_friction*lateral_wheel_speed*delta*self.mass);
	
	var detector_count = 0
	for detector in $Detectors.get_children():
		for goal in get_tree().get_nodes_in_group("goal"):
			if detector.overlaps_area(goal):
				detector_count += 1
	if detector_count == 4:
		self.current_time += delta
	else:
		self.current_time = 0.0
	$"..".progress = current_time/win_time
