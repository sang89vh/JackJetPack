extends Actor
class_name Player

export var stomp_impulse: = 800.0
export var jump_force: = -1.0

var run_speed: = 0
var direction: = Vector2.ZERO
var is_jump_interrupted: = false
var max_jumps = 2
var jump_count = 0
var is_smoke = false
#signal jump
signal die
signal done_starting
var can_die = true
# dash
export (int) var dash_length = 500
export (int) var dash_speed = 100
var dash_init_pos = Vector2()
var can_dash = true
var gravity_before_dash
var starting_dash = false

export var adjust_position_x := 10
export var alway_on_particales := false
# player state
enum {IDLE, RUN, JUMP, HURT, DEAD, DASH}
var is_on_starting = true
var state
var anim
var new_anim
var is_died := false
onready var animation_player = $AnimationPlayer
onready var jetpack_smoke = $Smoothing2D/JetpackSmoke
onready var explosion = $Smoothing2D/Explosion/AnimationPlayer
onready var audio_die = $Smoothing2D/AudioStreamPlayer2DDie
onready var timer_die = $Timer2Die
onready var timer_jetpack_smoke = $Timer2JetpackSmoke
onready var pistol = $Pistol

var is_jump_up = false

var remaining_bullet : int = 3

func change_state(new_state):
	#print_debug("player change_state " + str(new_state))
	state = new_state
	match state:
		IDLE:
			idle()
		RUN:
			run()
		HURT:
			hurt()
		JUMP:
			jump_up()
		DASH:
			dash()
		DEAD:
			die()

func _ready():
	print_debug("player ready 2")
	change_state(IDLE)
	#set_physics_process(false)

func _physics_process(delta: float) -> void:
	if is_on_starting:
		return
	# check player is dead
	# (not can_dash and starting_dash) and
	if is_on_wall() or is_on_ceiling() or is_on_floor():
		print_debug("on wall, celling, floor then go to die")
		change_state(DEAD)
		return
	
	# check is jump up
	if !is_jump_up and !is_smoke:
		#jetpack_smoke.play("idle")
		# Third argument is optional userdata, it can be any variable.
		_toggle_jetpack_smoke(false)
	
	# process dash
	if not can_dash:
		dash_process()
	elif starting_dash:
		change_state(DASH)
		return

	# calculate velocity and direction 
	direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed)

	# snap
	# var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	
	# check on jump up then change the snap to Vector Zero
	#if is_jump_up:
	#	snap = Vector2.ZERO
	
	# move and slide
	#_velocity = move_and_slide_with_snap(_velocity, snap, FLOOR_NORMAL, true)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL, true)
	
	#if is_on_floor() and not is_died:
	#	change_state(RUN)
	if is_jump_up:
		change_state(JUMP)

func get_direction() -> Vector2:
	var direction_y: = 0.0
	if is_jump_up:
		direction_y = jump_force
	else:
		direction_y = 0.0
	
	return Vector2(
		1,
		direction_y
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:

	var velocity: = linear_velocity
	if is_died:
		return velocity
	else:
		velocity.x = speed.x * direction.x
		# FIXED SPEED
		#velocity.x = run_speed
		if direction.y != 0.0:
			velocity.y = speed.y * direction.y
		return velocity

func hurt():
	new_anim = 'hurt'

func die() -> void:
	if not is_died and can_die:
		print_debug("go to die")
		is_died = true
		set_physics_process(false)
		jetpack_smoke.emitting = false
		explosion.play("Explode")
		animation_player.play("die")
		audio_die.play()
		
		timer_die.start()

func idle():
	new_anim = 'idle'
	
	can_dash = true
	
	run_speed = 0
	
	if new_anim != anim:
		anim = new_anim
		animation_player.play(new_anim)

func run():
	new_anim = 'run'

	can_dash = true
	
	run_speed = 600
		
	if new_anim != anim:
		anim = new_anim
		animation_player.play(new_anim)

func jump_up():
	new_anim = 'jump_up'
	
	if new_anim != anim:
		anim = new_anim
		animation_player.play(new_anim)
	
	is_jump_up = false

func done_starting():
	print_debug("done_starting")
	emit_signal("done_starting")
	is_on_starting = false
	change_state(RUN)

func _on_RayCast2D_revert_gravity():
	gravity = gravity * -1

# Dash
func dash():
	starting_dash = false
	if can_dash:
		print_debug("dash")
		# locked dash
		can_dash = false
		
		# new animation
		new_anim = 'dash'
		
		if new_anim != anim:
			anim = new_anim
			animation_player.play(new_anim)
		
		#$Rocket_Effect_02.visible = true
		#$Smoothing2D/GhostTrail.emitting = true
		can_die = false
		
		# back up current state
		dash_init_pos = self.position
		gravity_before_dash = self.gravity
		
		# skip current state
		self.gravity = 0
		self._velocity.y = 0
		
		# update speed X
		self._velocity.x = dash_speed * self.direction.x
		#actor.emit_signal("action_performed", "dash")

func dash_process():
	# runout of dash_length then stop dash and change state to init state then RUN
	if abs(dash_init_pos.x - self.position.x) >= dash_length:
		# restore gravity
		self.gravity = gravity_before_dash
		
		#$Rocket_Effect_02.visible = false
		#$Smoothing2D/GhostTrail.emitting = false
		can_die = true
		
		# new animation
		change_state(RUN)
		return

func _on_EnemyDetector_body_entered(body:KinematicBody2D) -> void:
	print_debug("_on_EnemyDetector_body_entered " )
	change_state(DEAD)

func _on_EnemyDetector_area_entered(area:Area2D):
	print_debug("_on_EnemyDetector_area_entered " + area.name)
	#if area.is_in_group("Enemies"):
	change_state(DEAD)

func _on_DashRing_dash_ring_entered():
	if not starting_dash:
		starting_dash = true

# # _on_JumpUpBtn_button_down => _physics_process => get_dirirection => move_and_slice => change_state(JUMP)
func _on_JumpUpBtn_button_down():
	if !is_jump_up:
		is_jump_up = true
		#jetpack_smoke.play("fire")
		# Third argument is optional userdata, it can be any variable.
		_toggle_jetpack_smoke(true)
		
func _toggle_jetpack_smoke(_emitting:bool):
	if jetpack_smoke.emitting != _emitting:
		jetpack_smoke.emitting = _emitting
	if _emitting:
		is_smoke = true
		timer_jetpack_smoke.start()

func _on_FireBtn_button_down():
	if remaining_bullet > 0 :
		remaining_bullet -=1
		PlayerData.set_remaining_bullet(remaining_bullet)
		var direction = Vector2(cos(rotation), sin(rotation))
		print_debug("_on_FireBullet1Btn_pressed x:" + str(direction.x) + " y:" + str(direction.y))
		pistol.shoot(direction, rotation)

func _on_Timer_timeout():
	remaining_bullet = 3
	PlayerData.set_remaining_bullet(remaining_bullet)

func _on_Timer2Die_timeout():
	PlayerData.deaths += 1
	queue_free()
	
	emit_signal("die")

func _on_Timer2JetpackSmoke_timeout():
	is_smoke = false

func _on_DashBtn_button_down():
	if not starting_dash:
		print_debug("_on_DashBtn_button_down")
		starting_dash = true
