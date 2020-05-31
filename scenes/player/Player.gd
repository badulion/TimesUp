extends KinematicBody2D

const MAX_SPEED = 500
const ACCELERATION = 20
const FRICTION_AIR = 0.1
const FRICTION_GROUND = 0.5

const UP = Vector2(0, -1)
const GRAVITY = 1500
const JUMP_SPEED = 1000

var velocity = Vector2()

const MAX_LIVES = 3
var lives

var is_grounded = false
var is_jump_button_pressed = false

export (PackedScene) var bow_scene
export (PackedScene) var laser_scene


signal shoot
signal player_die

func _ready():
	lives = MAX_LIVES
	get_tree().call_group("HUD", "update_lives", lives)
	_use_bow()

func _process(delta):
	_apply_gravity(delta)
	_get_input()
	_check_grounded()
	_check_jump()
	_move()
	_animate()

func _get_input():
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		velocity.x = clamp(velocity.x - ACCELERATION, -MAX_SPEED, MAX_SPEED)
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		velocity.x = clamp(velocity.x + ACCELERATION, -MAX_SPEED, MAX_SPEED)
	elif is_on_floor():
		velocity.x = lerp(velocity.x, 0, FRICTION_GROUND)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_AIR)
		
	if Input.is_action_just_pressed("jump"):
		is_jump_button_pressed = true
		$JumpTimer.start()
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
		
	if Input.is_action_just_pressed("attack"):
		emit_signal("shoot")
		
func _check_grounded():
	if is_on_floor():
		is_grounded = true
	elif is_grounded and $GroundedTimer.is_stopped():
		$GroundedTimer.start()
		
func _check_jump():
	if is_grounded and is_jump_button_pressed:
		velocity.y = -JUMP_SPEED
		$JumpAnimator.stop()
		$JumpAnimator.play("jump")
		is_jump_button_pressed = false
		is_grounded = false
		$GroundedTimer.stop()
		
func _move():
	velocity = move_and_slide(velocity, UP, true)
		
func _apply_gravity(delta):
	if is_on_floor():
		velocity.y = 0
	elif is_on_ceiling():
		velocity.y = 1
	else:
		velocity.y += delta*GRAVITY

func _animate():
	rotation = (PI/16)*(velocity.x/MAX_SPEED)
	
	if velocity.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func hurt(projectile):
	if $HurtTimer.is_stopped():
		if lives > 0:
			lives -= 1
			get_tree().call_group("HUD", "update_lives", lives)
			$HurtTimer.start()
			$HurtAnimator.play("hurt")
			$HurtAudio.play()
		else:
			emit_signal("player_die")
		projectile.destroy_projectile()

func _on_JumpTimer_timeout():
	is_jump_button_pressed = false


func _on_GroundedTimer_timeout():
	is_grounded = false

func _use_bow():
	for child in $Weapon.get_children():
		child.queue_free()
	var bow = bow_scene.instance()
	connect("shoot", bow, "_on_Player_shoot")
	$Weapon.add_child(bow)

func _use_laser():
	for child in $Weapon.get_children():
		child.queue_free()
	var laser = laser_scene.instance()
	connect("shoot", laser, "_on_Player_shoot")
	$Weapon.add_child(laser)

func _on_Weapon_ammo_depleted():
	_use_bow()
