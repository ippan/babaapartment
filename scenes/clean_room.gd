extends "res://scenes/room.gd"

var npc_count = 0
var elapsed = 0.0

var enter_times = {}

var action_count = 0

func is_dirty():
    return (npc_count > 2)

func on_enter_success(character):
    if character.id != 0:
        add_npc(1)

    enter_times[character.id] = elapsed

func add_npc(value):
    npc_count += value
    if npc_count < 0:
        npc_count = 0

    $emitter.is_active = is_dirty()


func can_enter(character):
    return true

func can_leave(character):
    if character.id == 0:
        return true
    return elapsed - enter_times[character.id] > 3.0

func room_action(character):
    if character.id != 0:
        return

    if not character.has_item("broom"):
        return

    character.power_mode_countdown = 1.0

    action_count += 1
    if action_count > 10:
        add_npc(-1)
        action_count -= 10


func _process(delta):
    elapsed += delta

    if is_dirty():
        get_parent().get_parent().get_parent().update_score(delta * 0.2)
