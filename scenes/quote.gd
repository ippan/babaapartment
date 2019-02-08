extends Sprite

func show_need(need):
    if need == "":
        hide()
    else:
        show()
        $need.texture = load("res://images/%s_need.png" % [ need ])