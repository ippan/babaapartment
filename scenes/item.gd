extends Node2D

export(String) var item_mode = "unique"
export(String) var item_name = "coffee"

func pick(character):

    if item_mode == "unique":
        queue_free()

    return get_data()

func get_data():
    var data = {}

    data.mode = item_mode
    data.name = item_name

    return data

func object_type():
    return "item"