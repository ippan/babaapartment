extends Node2D

var boundary = Vector2(0.0, 1.0)

var complaining = null

var npc_count = 0

var finished_quest = 0

var mood = 100.0

onready var counter = get_node("levels/0/counter")
onready var elevator = get_node("elevator")
onready var score = get_node("score")


onready var clean_rooms = [
    get_node("levels/2/pool"),
    get_node("levels/4/gym")
]

func _ready():
    randomize()

    boundary.x = $left_boundary.position.x
    boundary.y = $right_boundary.position.x

func clamp_boundary(origin_position):
    if origin_position.x < boundary.x:
        origin_position.x = boundary.x
    elif origin_position.x > boundary.y:
        origin_position.x = boundary.y

    return origin_position

func get_level_height(level):
    return get_node("levels/%s" % [ level ]).position.y

func generate_npc_id():
    npc_count += 1
    return npc_count

func update_score(delta):
    score.score -= delta

    if score.score < 0:
        get_tree().change_scene("res://scenes/game_end_fired.tscn")

func finish_quest():
    finished_quest += 1

    if finished_quest >= 15:
        get_tree().change_scene("res://scenes/game_end_win.tscn")

func update_mood(delta):
    mood -= delta * 0.7

    if mood < 0:
        get_tree().change_scene("res://scenes/game_end_no_mood.tscn")
    elif mood > 100.0:
        mood = 100.0

func _process(delta):
    update_mood(delta)
