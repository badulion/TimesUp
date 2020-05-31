extends CanvasLayer


func _ready():
	pass 

func update_weapon_cooldown(remaining, cooldown_time):
	$NinePatchRect/VBoxContainer/HBoxContainer/WeaponCooldown.max_value = cooldown_time*1000
	$NinePatchRect/VBoxContainer/HBoxContainer/WeaponCooldown.value = (cooldown_time-remaining)*1000


func set_max_time_fuel(max_fuel):
	$NinePatchRect/VBoxContainer/HBoxContainer3/TimeFuel.max_value = max_fuel
	
func update_time_fuel(fuel):
	$NinePatchRect/VBoxContainer/HBoxContainer3/TimeFuel.value = fuel

func update_lives(lives):
	for live in $NinePatchRect/HBoxContainer4.get_children():
		if int(live.name[-1]) < lives+1:
			live.set("visible", true)
		else:
			live.set("visible", false)

func update_enemies(current_enemies_count, total_enemies_count):
	$NinePatchRect/VBoxContainer/HBoxContainer2/EnemiesCount.text = "%d/%d" % [current_enemies_count, total_enemies_count]

func update_ammo(ammo_count):
	if ammo_count == -1:
		$NinePatchRect/VBoxContainer/HBoxContainer/WeaponAmmo.text = "(∞)"
	else:
		$NinePatchRect/VBoxContainer/HBoxContainer/WeaponAmmo.text = "(%d)" % ammo_count
		
func update_gun_name(name):
	$NinePatchRect/VBoxContainer/HBoxContainer/WeaponName.text = name
