extends Node2D

const FORWARD = Vector2(1, 0)

export (PackedScene) var projectile_scene

var shot_ready = true

var velocity = Vector2()

export var starting_ammo = 0
export var cooldown_time = 0.5
var ammo = 0

signal ammo_depleted
export var gun_name = "Laser"


func _ready():
	get_tree().call_group("HUD", "update_ammo", starting_ammo)
	get_tree().call_group("HUD", "update_gun_name", gun_name)
	ammo = starting_ammo
	$ShotCooldown.wait_time = cooldown_time
	connect("ammo_depleted", get_parent().get_parent(), "_on_Weapon_ammo_depleted")

func _process(delta):
	_orient_gun()
	get_tree().call_group("HUD", "update_weapon_cooldown", $ShotCooldown.time_left, $ShotCooldown.wait_time)
	
	
func _orient_gun():
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x < 0:
		scale.y = -1
	else:
		scale.y = 1
	global_rotation = FORWARD.angle_to(mouse_direction)

		
func _shoot():
	if shot_ready:
		#spend ammo:
		if ammo > 0:
			ammo -= 1
			get_tree().call_group("HUD", "update_ammo", ammo)
		
		#various effects
		TimeControl.speedup()
		get_tree().call_group("Camera", "shake")
		
		#shot timer
		shot_ready = false
		$ShotCooldown.start()
		
		#spawn projectile
		var projectile = projectile_scene.instance()
		projectile.collision_layer = 8
		projectile.collision_mask = 22
		add_child(projectile)
		
		if ammo == 0:
			emit_signal("ammo_depleted")
			queue_free()

func _on_ShotCooldown_timeout():
	shot_ready = true

func _on_Player_shoot():
	_shoot()
