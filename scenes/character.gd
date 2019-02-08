extends Node2D

var id = -1

var current_room = null

export var current_level = -1

export var speed = 100.0

onready var sprite = get_node("sprite")
onready var item = get_node("sprite/item")

var item_data = null

var movement_time = 0.0

var elapsed = 0.0

var power_mode_countdown = 0.0

func on_arrived(room, level):
    pass

func on_enter(room):
    pass

func on_leave(room):
    pass

func is_in_room():
    return current_room != null

func hold_item(data):
    item_data = data

    item.texture = load("res://images/%s_hand.png" % data.name)
    item.show()

func throw_item():
    if item_data.mode == "unique":
        var item_instance = load("res://scenes/%s.tscn" % [ item_data.name ]).instance()
        get_parent().add_child(item_instance)
        item_instance.position = position

    clear_item()

func clear_item():
    item.hide()
    item_data = null

func has_item(item_name = ""):
    if item_data == null:
        return false

    if item_name == "":
        return true

    return (item_data.name == item_name)

func apply_movement(direction, delta, clamp_position = true):
    var x_movement = direction * delta * speed
    movement_time += delta

    if direction > 0:
        sprite.flip_h = true
    elif direction < 0:
        sprite.flip_h = false

    position.x += x_movement

    if clamp_position:
        position = get_parent().clamp_boundary(position)

    sprite.rotation_degrees = sin(movement_time * speed * 0.1) * 15.0

func on_update(delta):
    pass

func _process(delta):
    elapsed += delta

    var angle = 10.0
    var modifier = 0.05

    if power_mode_countdown > 0.0:
        angle = 20.0
        modifier = 0.1
        power_mode_countdown -= delta

    item.rotation_degrees = sin(elapsed * speed * modifier) * angle

    on_update(delta)