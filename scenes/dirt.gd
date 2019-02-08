extends Sprite

var size = 1.0
var life = 5.0
var scale_speed = 0.1

var elapsed = 0.0

func _ready():
    size = randf() + 0.5
    life = 1.0 + randf() * 5.0

    if randi() % 2 == 0:
        flip_v = true

    modulate.a = 0.0
    rotation_degrees = randf() * 360.0

func _process(delta):
    elapsed += delta

    scale += Vector2(1.0, 1.0) * scale_speed * delta

    var t = (elapsed / life)
    if t < 0.5:
        modulate.a = t / 0.5
    else:
        modulate.a = (1.0 - t) / 0.5

    if elapsed > life:
        queue_free()