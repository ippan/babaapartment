extends Node2D

var score = 100.0

onready var rope = get_node("rope")
onready var fire_point = get_node("rope/fire_point")
onready var fire = get_node("fire")
onready var angry = get_node("boom/angry")
onready var boom = get_node("boom")

var elapsed = 0.0

func _process(delta):
    elapsed += delta

    var t = score / 100.0
    rope.scale.y = t

    fire.global_position = fire_point.global_position

    fire.rotation_degrees = randi() % 360

    #var angry_scale = (sin(elapsed) + 1.0) * 0.2 + 1.0
    #angry.scale = Vector2(angry_scale, angry_scale)

    var boom_scale = (sin(elapsed) + 1.0) * 0.2 + 1.0
    boom.scale = Vector2(boom_scale, boom_scale)





