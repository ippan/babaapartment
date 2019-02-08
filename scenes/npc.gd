extends "res://scenes/character.gd"

var target = null

var my_home = null

var quest_types = [ "item", "walk" ]
var quest_items = [ "coffee", "ladder" ]

var quest_type = ""

var quest_item = ""

var state = 0
var last_state = 0

var elevator_offset_x = 0
var target_offset_x = 0

const GOTO_TARGET = 1
const GOTO_ELEVATOR = 2
const PLAY = 3
const BACK_HOME = 4
const WAITING_ITEM = 5
const THROW_ITEM = 6

func _ready():
    random_npc()

func random_npc():
    var index = randi() % 4 + 1

    $sprite.texture = load("res://images/npc_0%s.png" % [ index ])

func show_item(enabled):
    item.visible = enabled

func on_arrived(room, level):
    if level != get_target_level():
        return

    current_room.leave(self)
    state = last_state

func prepare_item_quest():
    quest_item = quest_items[randi() % quest_items.size()]
    generate_item_target()
    $quote.show_need(quest_item)
    target_offset_x = 32
    state = GOTO_TARGET

func prepare_walk_quest():
    var clean_rooms = get_main().clean_rooms
    target = clean_rooms[randi() % clean_rooms.size()]
    target_offset_x = randi() % 160 + 30
    state = GOTO_TARGET

func generate_quest():
    quest_item = ""
    $quote.show_need("")
    quest_type = quest_types[randi() % quest_types.size()]

    call("prepare_%s_quest" % [ quest_type ])

func generate_item_target():
    if get_main().complaining == null and randi() % 4 == 0:
        get_main().complaining = self
        target = get_main().counter
        return

    target = my_home

func get_target_level():
    if target == null:
        return current_level

    var target_level = target.get_level()
    if target_level == -1:
        return current_level

    return target_level

func get_main():
    return get_parent()

func state_0(delta):
    pass

func go_home():
    target = my_home
    target_offset_x = 32
    state = BACK_HOME
    quest_type = "home"
    last_state = BACK_HOME

func on_target_arrived():
    if quest_type == "walk":
        if target.is_dirty():
            get_main().update_score(3.0)
        else:
            target.enter(self)

        go_home()
    elif quest_type == "home":
        target.enter(self)
    elif quest_type == "item":
        state = WAITING_ITEM
        elapsed = 0


# goto target
func state_1(delta):
    last_state = GOTO_TARGET
    if is_in_room():
        current_room.leave(self)
        return

    if target.get_level() == current_level:
        if move_to(target.global_position + Vector2(target_offset_x, 0), delta):
            on_target_arrived()
    else:

        state = GOTO_ELEVATOR
        elevator_offset_x = randi() % 40 - 20

func state_4(delta):
    if is_in_room():
        current_room.leave(self)
        return

    if target.get_level() == current_level:
        if move_to(target.global_position + Vector2(target_offset_x, 0), delta):
            on_target_arrived()
    else:
        state = GOTO_ELEVATOR
        elevator_offset_x = randi() % 40 - 20

func on_enter(room):
    $quote.show_need("")

func home_arrived(room):
    if has_item():
        state = THROW_ITEM
        elapsed = 0.0
    else:
        state = 0

func on_leave(room):
    $quote.show_need(quest_item)

func move_to(move_target_position, delta):
    move_target_position.y = position.y

    var distance = position.distance_to(move_target_position)

    if distance < 5:
        return true
    else:
        var movement = speed * delta

        if movement > distance:
            position = move_target_position
            return true
        else:
            var direction = sign(move_target_position.x - position.x)
            apply_movement(direction, delta)
    return false

# goto elevator
func state_2(delta):
    if is_in_room():
        return

    var elevator = get_main().elevator

    if move_to(elevator.global_position + Vector2(elevator_offset_x, 0), delta):
        elevator.enter(self)

func state_5(delta):
    elapsed += delta
    if elapsed > 10.0:
        get_main().update_score(delta * 0.2)

func state_6(delta):
    elapsed += delta
    if elapsed > 3.0:
        state = 0
        throw_item()

func accept_item(target_item_data):
    if state != WAITING_ITEM:
        return false

    if target_item_data.name != quest_item:
        return false

    hold_item(target_item_data)

    $quote.show_need("")
    quest_item = ""

    if get_main().complaining == self:
        get_main().complaining = null

    get_main().finish_quest()

    go_home()

    return true

func on_update(delta):
    callv("state_%s" % [ state ], [ delta ])