extends Node2D

var countdown = 0.0

var interval = 0.5

func _process(delta):

    if get_parent().mood > 50.0:
        $sprite.visible = false
        return

    countdown -= delta

    if countdown < 0.0:
        countdown += interval

        $sprite.visible = not $sprite.visible
