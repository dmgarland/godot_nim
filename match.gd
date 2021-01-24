extends RigidBody2D

signal match_clicked

var dragging: bool = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("match_clicked", self)

func _physics_process(_delta):
	if dragging:
		global_transform.origin = get_global_mouse_position()
		
func grab():
	if !dragging:
		mode = RigidBody2D.MODE_STATIC
		dragging = true
		
func release(impulse: Vector2 = Vector2.ZERO):
	if dragging:
		mode = RigidBody2D.MODE_RIGID
		apply_central_impulse(impulse)		
		dragging = false
