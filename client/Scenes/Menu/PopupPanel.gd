extends PopupPanel

onready var username_field : LineEdit = $VBoxContainer/VBoxContainer/LineEdit
onready var cabin_field : ColorPickerButton = $VBoxContainer/VBoxContainer2/HBoxContainer/Cabin/ColorPicker
onready var cargo_field : ColorPickerButton = $VBoxContainer/VBoxContainer2/HBoxContainer/Cargo/ColorPicker

func _on_OptionsButton_pressed():
	self.popup()
	pass # Replace with function body.

func _on_PopupPanel_about_to_show():
	username_field.text = $"/root/GameManager".player_data.username
	print($"/root/GameManager".player_data.cabin_color)
	cabin_field.set_pick_color($"/root/GameManager".player_data.cabin_color)
	$"VBoxContainer/VBoxContainer2/ViewportContainer/Viewport/player_h".modulate = $"/root/GameManager".player_data.cabin_color
	print($"/root/GameManager".player_data.cargo_color)
	cargo_field.set_pick_color($"/root/GameManager".player_data.cargo_color)
	$"VBoxContainer/VBoxContainer2/ViewportContainer/Viewport/container_h".modulate = $"/root/GameManager".player_data.cargo_color
	pass # Replace with function body.


func _on_CancelButton_pressed():
	self.hide()
	pass # Replace with function body.


func _on_SaveButton_pressed():
	$"/root/GameManager".player_data.username = username_field.text
	$"/root/GameManager".player_data.cabin_color = cabin_field.color.to_html()
	$"/root/GameManager".player_data.cargo_color = cargo_field.color.to_html()
	$"/root/GameManager".save_data()
	self.hide()
	pass # Replace with function body.


func _on_Cabin_color_changed(color):
	$"VBoxContainer/VBoxContainer2/ViewportContainer/Viewport/player_h".modulate = color
	pass # Replace with function body.


func _on_Cargo_color_changed(color):
	$"VBoxContainer/VBoxContainer2/ViewportContainer/Viewport/container_h".modulate = color
	pass # Replace with function body.
