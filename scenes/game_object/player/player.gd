extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var velocity_component = $VelocityComponent
@onready var health_component = $HealthComponent
@onready var visuals = $Visuals
@onready var health_bar = $HealthBar
@onready var damage_interval_timer = $DamageIntervalTimer

@onready var base_speed = 0

@onready var light = $Visuals/PointLight2D;

@onready var inventory = $Inventory;

var number_colliding_bodies = 0

func _ready():
	base_speed = velocity_component.max_speed
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	health_component.health_changed.connect(on_health_changed)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	update_health_display()
	
func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return 0
	health_component.damage(1)
	damage_interval_timer.start()
	print(health_component.current_health)

func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func get_movement_vector() -> Vector2:	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)

func _on_game_day_night_change(time):
	print("Player: ", time);
	if time == 0:
		light.hide()
	else:
		light.show()
		
func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	
func on_health_changed():
	GameEvents.emit_player_damaged()
	update_health_display()
	
func update_health_display():
	health_bar.value = health_component.get_health_percent()

func on_damage_interval_timer_timeout():
	check_deal_damage()
