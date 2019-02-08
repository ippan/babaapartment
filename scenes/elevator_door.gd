extends Node2D

const OPENING = 1
const OPENED = 2
const CLOSING = 3

const open_duration = 0.8
const close_duration = 0.8

var state = 0

var elapsed = 0.0

func open_door():
    elapsed = 0.0
    state = OPENING

func close_door():
    elapsed = 0.0
    state = CLOSING

func state_0(delta):
    pass

func state_1(delta):
    elapsed += delta

    if elapsed > open_duration:
        elapsed = open_duration
        state = 2
        get_parent().door_opened(self)

    var offset = 1.0 - elapsed / open_duration
    $left.scale.x = offset
    $right.scale.x = offset

func state_2(delta):
    pass

func light(enabled):
    $light/light_on.visible = enabled

func state_3(delta):
    elapsed += delta

    if elapsed > close_duration:
        elapsed = close_duration
        state = 0
        get_parent().door_closed(self)

    var offset = elapsed / close_duration
    $left.scale.x = offset
    $right.scale.x = offset

func _process(delta):
    callv("state_%s" % [ state ], [ delta ])