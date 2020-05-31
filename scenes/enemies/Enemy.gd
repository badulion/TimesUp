extends KinematicBody2D

const MAX_SPEED = 500
const ACCELERATION = 20
const FRICTION_AIR = 0.1
const FRICTION_GROUND = 0.5

const UP = Vector2(0, -1)
const GRAVITY = 1500
const JUMP_SPEED = 1000

var velocity = Vector2()

onready var Player = get_tree().get_root().find_node("Player", true, false)

signal die

func _ready():
	$DieTimer.wait_time = 2
	
func _process(delta):
	_move()
	_animate()
	_apply_gravity(delta)

func _move():
	move_and_slide(velocity, UP, true)

		
func _animate():
	rotation = (PI/16)*(velocity.x/MAX_SPEED)
	var player_direction = Player.global_position - global_position
	if player_direction.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func _apply_gravity(delta):
	if is_on_floor():
		velocity.y = 0
	elif is_on_ceiling():
		velocity.y = 1
	else:
		velocity.y += delta*GRAVITY
		
func hurt(projectile):
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	z_index = 10
	$DieTimer.start()
	$Weapon.queue_free()
	projectile.destroy_projectile()
	TimeControl.add_fuel()


func _on_DieTimer_timeout():
	emit_signal("die")
	queue_free()
