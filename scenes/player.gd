extends "res://scenes/character.gd"

func _ready():
    id = 0
    z_index = 40

func handle_movement(delta):
    var direction = 0

    if Input.is_action_pressed("ui_left"):
        direction -= 1

    if Input.is_action_pressed("ui_right"):
        direction += 1

    if direction == 0:
        return

    apply_movement(direction, delta)

func try_enter_room():

    var room = find_object("room")
    if room != null:
        room.enter(self)

func try_leave_room():
    current_room.leave(self)

func room_action():
    current_room.room_action(self)

func find_object(object_type):
    var objects = find_objects(object_type)
    if objects.size() > 0:
        return objects[0]
    return null

func find_objects(object_type):
    var space_state = get_world_2d().direct_space_state

    var game_objects = space_state.intersect_point(position)

    if game_objects.size() == 0:
        return []

    var results = []

    for game_object in game_objects:
        if game_object.collider.object_type() == object_type:
            results.append(game_object.collider)

    return results

func find_item():
    var items = find_objects("item")
    for item in items:
        # get unique item first
        if item.item_mode == "unique":
            return item

    if items.size() > 0:
        return items[0]

    return null


func try_pick():
    var item = find_item()

    if item != null:
        hold_item(item.pick(self))
    else:
        try_enter_room()

func try_action():
    var npc = find_object("npc")

    if npc != null:
        if npc.accept_item(item_data):
            clear_item()
    else:
        try_enter_room()

func handle_action(delta):
    if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
        if is_in_room():
            try_leave_room()
        else:
            try_enter_room()

    if Input.is_action_just_pressed("ui_accept"):
        if is_in_room():
            room_action()
        elif has_item():
            try_action()
        else:
            try_pick()

    if Input.is_action_just_pressed("ui_cancel"):
        if has_item():
            throw_item()

func on_update(delta):
    if not is_in_room():
        handle_movement(delta)
    handle_action(delta)

