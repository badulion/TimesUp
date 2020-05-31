extends Area2D

const FORWARD = Vector2(1, 0)

const GRAVITY = 300

const AERODYNAMIC_FRICTION = 0.01


export var projectile_speed = 1000
export var initial_offset = 120
export var affected_by_gravity = false

var is_moving = true


var velocity = Vector2()
var parent_velocity = Vector2()

func _ready():
	set_as_toplevel(true)
	rotation = get_parent().rotation
	velocity = FORWARD.rotated(rotation)*projectile_speed 
	velocity = velocity
	
	position = get_parent().global_position+velocity.normalized()*initial_offset
	var new_parent = get_parent().get_parent()
	get_parent().remove_child(self) # error here  
	new_parent.add_child(self) 

func _process(delta):
	if affected_by_gravity:
		velocity.y += GRAVITY*delta
	if is_moving:
		position += velocity*delta
		rotation = FORWARD.angle_to(velocity.normalized())

func _on_Projectile_body_entered(body):
	if body.collision_layer == 2: #terrain hit
		destroy_projectile()
	elif body.collision_layer == 4: #enemy hit
		body.hurt(self)
	elif body.collision_layer == 1: #player hit
		body.hurt(self)

func _on_Projectile_area_entered(area):
	if area.collision_layer == 4:
		area.hurt()
		destroy_projectile()
	elif area.collision_layer == 8:
		area.destroy_projectile()
	elif area.collision_layer == 16:
		area.destroy_projectile()

func destroy_projectile():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


