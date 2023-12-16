extends Node2D

enum TimeOfDay { Day, Night }

var currentTime;

signal day_night_change;

@onready var m = $CanvasModulate;

# Called when the node enters the scene tree for the first time.
func _ready():
	currentTime = TimeOfDay.Day;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	if currentTime == TimeOfDay.Day:
		print("Night");
		currentTime = TimeOfDay.Night;
		m.color = Color(0.26, 0.26, 0.26)
	else:
		print("Day")
		m.color = Color(1, 1, 1);
		currentTime = TimeOfDay.Day;
	# Signal
	day_night_change.emit(currentTime);
