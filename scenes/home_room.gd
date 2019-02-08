extends "res://scenes/room.gd"

const NPC = preload("res://scenes/npc.tscn")

const OPENING = 1
const OPEN_WAIT = 2
const CLOSING = 3

const open_duration = 0.8
const close_duration = 0.8

var state = 0
var elapsed = 0.0

var npc = null

var event_countdown = 100.0

var step = 0

func _ready():
    call_deferred("generate_npc")
    reset_countdown()

func reset_countdown():
    event_countdown = 5.0 + (randi() % (300 - get_step_diffcult()))
    step += 1

func get_step_diffcult():
    if step > 4:
        return 240
    return step * 3


func generate_npc():
    npc = NPC.instance()
    get_main().add_child(npc)
    npc.id = get_main().generate_npc_id()
    npc.position = global_position + Vector2(32, 0)
    npc.position.y = get_height()
    npc.current_level = get_level()
    npc.my_home = self
    internal_enter(npc)

func get_main():
    return get_parent().get_parent().get_parent()

func can_enter(character):
    if character.id == 0:
        return false

    return true

func can_leave(character):
    if character.id == 0:
        return false

    return (state == OPEN_WAIT)

func on_enter_success(character):
    state = CLOSING
    elapsed = 0.0

    character.home_arrived(self)

func state_0(delta):
    event_countdown -= delta

    if event_countdown < 0.0:
        elapsed = 0.0
        npc.generate_quest()
        state = OPENING

# opening
func state_1(delta):
    elapsed += delta

    if elapsed > open_duration:
        elapsed = open_duration
        state = OPEN_WAIT

    $sprite.scale.x = 1.0 - (elapsed / open_duration)

func state_2(delta):
    pass

# closing
func state_3(delta):
    elapsed += delta

    if elapsed > close_duration:
        elapsed = close_duration
        reset_countdown()
        state = 0

    $sprite.scale.x = elapsed / open_duration

func get_level():
    return int(get_parent().name)

func get_height():
    return get_main().get_level_height(get_level())

func _process(delta):
    callv("state_%s" % [ state ], [ delta ])