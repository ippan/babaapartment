extends RigidBody2D

func accept_item(item_data):
    return get_parent().accept_item(item_data)

func object_type():
    return "npc"