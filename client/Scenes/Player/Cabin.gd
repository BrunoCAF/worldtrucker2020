extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var wheel_friction = 10
export var max_speed = 200
export var max_accel = 200
var target_speed = 0
var foward_friction = 1

export var max_steer = 0.8
var steer = 0
var target_steer = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	$player.modulate = $"/root/GameManager".player_data["cabin_color"]
	pass # Replace with function body.

func _physics_process(delta):
	self.target_steer = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	self.target_steer *= self.max_steer
	
	self.steer = lerp (self.steer, self.target_steer, 0.1)
	$FrontWheel.rotation = self.steer
	
	
	var front_offset = $FrontWheel.global_position - self.global_position
	var front_wheel_speed = self.linear_velocity + self.angular_velocity*front_offset.rotated(PI/2)
	
	var back_offset = $BackWheel.global_position - self.global_position
	var back_wheel_speed = self.linear_velocity + self.angular_velocity*back_offset.rotated(PI/2)
	
	var current_speed = front_wheel_speed.dot(-$FrontWheel.global_transform.y)
	self.target_speed = Input.get_action_strength("player_accel") - Input.get_action_strength("player_back")
	self.target_speed *= 1 - Input.get_action_strength("player_brakes")
	self.target_speed *= self.max_speed
	var foward_force = -$FrontWheel.global_transform.y * (target_speed - current_speed) * foward_friction
	foward_force = foward_force.normalized()*clamp(foward_force.length(), 0, max_accel) 
	
	var front_friction = -front_wheel_speed.project($FrontWheel.global_transform.x)*self.wheel_friction
	var back_friction = -back_wheel_speed.project($BackWheel.global_transform.x)*self.wheel_friction
	
	self.apply_impulse(front_offset, front_friction*delta)
	self.apply_impulse(front_offset, foward_force*delta)
	
	self.apply_impulse(back_offset, back_friction*delta)
	
