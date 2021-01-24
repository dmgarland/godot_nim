extends Node2D

export (PackedScene) var Cup
export (PackedScene) var Match

var TOTAL_CUPS: int = 4;

func _ready():
	for i in TOTAL_CUPS:
		print(i)
		var cup = Cup.instance()
		add_child(cup)
