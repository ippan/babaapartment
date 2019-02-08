extends "res://scenes/room.gd"

export var fade_direction = -1
export var direction = 1

export var width = 150

func can_enter(character):
    return characters.size() == 0

func can_leave(character):
    return character_state == 2

var character_state = 0

var states = []

func on_enter_success(character):
    character_state = 0
    states = [ character.position.x + fade_direction * width, character.position.x + 0.0 ]

func check_finished(movement_direction, character):
    if movement_direction < 0 and character.position.x > states[character_state]:
        return false

    if movement_direction > 0 and character.position.x < states[character_state]:
        return false

    return true

func state_0(character, delta):
    character.apply_movement(fade_direction, delta, false)

    if not check_finished(fade_direction, character):
        return

    character.position.y = get_next_level_height()
    character_state += 1

func state_1(character, delta):
    character.apply_movement(-fade_direction, delta, false)

    if not check_finished(-fade_direction, character):
        return

    character.current_level = get_next_level()

    character_state += 1

    leave(character)

func get_next_level():
    return get_level() + direction

func get_next_level_height():
    return get_parent().get_parent().get_parent().get_level_height(get_next_level())

func move_character(delta):
    pass

func _process(delta):
    if characters.size() == 0:
        return
    var character = characters.values()[0]
    callv("state_%s" % [ character_state ], [ character, delta ])