extends "res://scenes/room.gd"

const images = [
    preload("res://images/eat01.png"),
    preload("res://images/eat02.png"),
    preload("res://images/eat03.png"),
]

var countdown = 0.0

var interval = 0.3

var image_index = 0


func can_enter(character):
    return (character.id == 0)

func can_leave(character):
    return true

func on_enter_success(character):
    character.hide()
    $sprite.show()


func on_leave_success(character):
    character.show()
    $sprite.hide()


func _process(delta):
    if characters.size() == 0:
        return

    countdown -= delta

    if countdown < 0.0:
        countdown += interval
        image_index = (image_index + 1) % images.size()
        $sprite.texture = images[image_index]

    get_parent().get_parent().get_parent().update_mood(-delta * 4.0)




