extends Node2D

export (PackedScene) var Cup
export (PackedScene) var Match

var TOTAL_CUPS: int = 4
var held_match = null
var cups = []
var players = [{ 'name': 'Player'}, { 'name': 'Computer'}]
var player = 0

func _ready():
	randomize()
	players.shuffle()
	
	for i in TOTAL_CUPS:
		var cup = Cup.instance()
		var cup_offset = Vector2(i * 120, 0)
		cup.translate(cup_offset)
		add_child(cup)
		cups.append(cup)
		
		var matches = (2 * i + 1)
		for j in matches:
			var match_offset = cup_offset + Vector2(j * 10, 0)
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

func current_player():
	return players[player]
	
func computers_turn():
	return current_player().name == 'Computer'
	
func total_matches():
	var total_matches = 0
	for cup in cups:
		total_matches += cup.count()
	return total_matches

func _next_turn():	
	if total_matches() == 0:
		print("%s wins!" % current_player().name)
		
	player = (player + 1) % 2
	print("It's %s's turn" % current_player().name)
	
	if computers_turn():
		calculate_move()
		var timer = Timer.new()
		timer.wait_time = 1
		timer.one_shot = true
		timer.autostart = true
		timer.connect("timeout", self, "_next_turn")
		add_child(timer)

	
func calculate_move():
	for i in cups.size():
		var cup = cups[i]
		var to_take = 1
		#print("cup %s has %s matches" % [i, cup.count()])
		while to_take <= cup.count():
			var move = cup.count() - to_take
			for j in cups.size():
				if i != j:
					move = move ^ cups[j].count()

			if(move == 0):
				#print('Taking %s matches from cup %s is a good move' % [to_take, i])
				cup.remove(to_take)
				return
				
			to_take += 1

	# If we got here it was our turn first from the balanced matches
	var random_cup = cups[round(rand_range(0, cups.size() - 1))]
	random_cup.remove(round(rand_range(1, random_cup.count())))
	
