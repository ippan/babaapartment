extends Node2D

const commands = [ "ui_left", "ui_right", "ui_up", "ui_down", "ui_accept", "ui_cancel" ]

var elapsed = 0.0

func _process(delta):

    elapsed += delta

    for command in commands:
        if Input.is_action_just_pressed(command):
            if elapsed > 3.0:
                get_tree().change_scene("res://scenes/title.tscn")
                return