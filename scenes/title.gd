extends Node2D

const commands = [ "ui_left", "ui_right", "ui_up", "ui_down", "ui_accept", "ui_cancel" ]

func _process(delta):
    for command in commands:
        if Input.is_action_just_pressed(command):
            get_tree().change_scene("res://scenes/main.tscn")
            return