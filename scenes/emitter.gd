extends Node2D

export var width = 180
export var height = 120

export var scene = ""

var scene_object = null

var is_active = false

export var interval = 1.0

var countdown = 0.0

func _process(delta):
    if not is_active:
        return

    if scene_object == null:
        scene_object = load("res://scenes/%s.tscn" % [ scene ])

    countdown -= delta

    if countdown < 0.0:
        countdown += interval

        var child = scene_object.instance()
        add_child(child)
        child.position.x = randi() % width - width / 2.0
        child.position.y = randi() % height - height / 2.0


