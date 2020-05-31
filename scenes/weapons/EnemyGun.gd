extends Node2D

const FORWARD = Vector2(1, 0)

onready var Player = get_tree().get_root().find_node("Player", true, false)

export (PackedScene) var projectile_scene
export var is_affected_by_gravity = false

var shot_ready = true

var velocity = Vector2()

var is_on_screen = false

var is_player_visible = false


func _ready():
	pass

func _process(delta):
	_check_player_visibility()
	_orient_gun()
	_shoot()
	update()
	
func _orient_gun():
	var player_direction = (Player.global_position - global_position)
	if player_direction.x < 0 and is_player_visible:
		$Sprite.scale.y = -1
	else:
		$Sprite.scale.y = 1
	
	rotation = FORWARD.angle_to(player_direction)
	$RayCast2D.rotation = 0
	if is_affected_by_gravity:
		rotation -= 0.5*asin(500*player_direction.x/2250000)
		$RayCast2D.rotation = 0.5*asin(500*player_direction.x/2250000)
		
	if is_player_visible:
		$Sprite.rotation = 0
	else:
		$Sprite.global_rotation = 0

func _check_player_visibility():
	if is_on_screen and $RayCast2D.is_colliding() and $RayCast2D.get_collider().name == "Player":
		is_player_visible = true
	else:
		is_player_visible = false
		
		
func _shoot():
	if shot_ready and is_player_visible: # and player_in_sight
		shot_ready = false
		$ShotCooldown.start()
		velocity = get_parent().velocity
		var projectile = projectile_scene.instance()
		projectile.collision_layer = 16
		projectile.collision_mask = 3
		add_child(projectile)

func _on_ShotCooldown_timeout():
	shot_ready = true


func _on_VisibilityNotifier2D_screen_entered():
	is_on_screen = true
	$RayCast2D.enabled = true

func _on_VisibilityNotifier2D_screen_exited():
	is_on_screen = false
	$RayCast2D.enabled = false
