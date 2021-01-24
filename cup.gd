extends StaticBody2D

var matches

func _ready():
	matches = []

func _on_match_entered(body):
	if body is RigidBody2D:
		matches.append(body)
	
func _on_match_exited(body):	
	if body is RigidBody2D:
		matches.erase(body)

func count():
	return matches.size()

func remove(count: int):
	for i in count:		
		matches[i].apply_central_impulse(Vector2(30.0, -1000.0))
