extends Node2D

export (PackedScene) var Cup
export (PackedScene) var Match

var TOTAL_CUPS: int = 4
var held_match = null

func _ready():	
	for i in TOTAL_CUPS:		
		var cup = Cup.instance()
		var cup_offset: Vector2 = Vector2(i * 120, 0)
		cup.translate(cup_offset)
		add_child(cup)

		for j in (2 * i + 1):
			var match_offset: Vector2 = cup_offset + Vector2(j * 10, 0)			
			var m = Match.instance()
			m.translate(match_offset)
			m.connect("match_clicked", self, "_drag_match")
			add_child(m)		


	
	
func _drag_match(m):	
	if !held_match:
		held_match = m
		m.grab()
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:		
		if held_match and !event.pressed:			
			var speed: Vector2 = Input.get_last_mouse_speed()
			var clamped = Vector2(clamp(speed.x, -10, 10), clamp(speed.y, -10, 10))			
			held_match.release(clamped)
			held_match = null
	
