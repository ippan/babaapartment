extends "res://scenes/room.gd"

var level = 0
var elapsed = 0.0

var state = 0
var direction = -1

var moving_duration = 0.8
var waiting_duration = 0.5


const MOVING = 0
const OPENING = 1
const OPENED = 2
const CLOSING = 3

func _ready():
    get_door().light(true)

func door_opened(door):
    state = OPENED

    for character in characters.values():
        character.on_arrived(self, level)

func door_closed(door):
    if level == 4 or level == 0:
        direction = -direction

    get_door().light(false)

    level += direction

    get_door().light(true)

    state = MOVING

func can_enter(character):
    if character.current_level != level:
        return false

    return state != MOVING

func can_leave(character):
    return state != MOVING

func get_door(door_level = -1):
    if door_level == -1:
        door_level = level
    return get_node("door_%s" % door_level)

# moving
func state_0(delta):
    elapsed += delta

    if elapsed > moving_duration:
        move_characters()
        state = OPENING
        get_door().open_door()
        elapsed = 0.0

func get_level():
    return -1

# opening
func state_1(delta):
    pass

# opned
func state_2(delta):
    elapsed += delta
    if elapsed > waiting_duration:
        state = CLOSING
        get_door().close_door()
        elapsed = 0.0

func move_characters():
    var level_height = get_parent().get_level_height(level)
    for character in characters.values():
        character.position.y = level_height
        character.current_level = level


func _process(delta):
    callv("state_%s" % [ state ], [ delta ])