extends Node2D

var characters = {}

func enter(character):
    if not can_enter(character):
        on_enter_fail(character)
        return

    internal_enter(character)
    on_enter_success(character)

func internal_enter(character):

    characters[character.id] = character

    character.current_room = self
    character.on_enter(self)
    character.z_index = 15


func leave(character):
    if not characters.has(character.id):
        return

    if not can_leave(character):
        on_leave_fail(character)
        return

    characters.erase(character.id)

    character.z_index = 30
    if character.id == 0:
        character.z_index += 10
    character.on_leave(self)
    character.current_room = null
    on_leave_success(character)

func on_enter_success(character):
    pass

func on_enter_fail(character):
    pass

func on_leave_success(character):
    pass

func on_leave_fail(character):
    pass

func get_enter_point():
    return position

func get_level():
    return int(get_parent().name)

func can_enter(character):
    return false

func can_leave(character):
    return false

func room_action(character):
    pass

func object_type():
    return "room"