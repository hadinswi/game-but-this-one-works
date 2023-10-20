extends KinematicBody2D

# Movement parameters
var speed = 300
var acceleration = 1500
var friction = 2000
var deceleration = 3000

# Jump parameters
var jump_power = -600
var gravity = 500
var max_fall_velocity = 2000
var fall_acceleration = 3000
var max_jump_time = 0.3
var extra_jump_power = -0  # Additional jump power when holding the jump button

# Current velocity of the character
var velocity = Vector2()

# Jump state variables
var is_jumping = false
var can_jump = true
var jump_timer = 0.0

func _process(delta):
	process_input(delta)
	apply_gravity(delta)
	move_and_slide(velocity, Vector2(0, -1))

func process_input(delta):
	# Handle horizontal movement
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + acceleration * delta, speed)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - acceleration * delta, -speed)
	else:
		# If not moving, apply deceleration and friction
		if velocity.x > 0:
			velocity.x = max(0, velocity.x - deceleration * delta)
		elif velocity.x < 0:
			velocity.x = min(0, velocity.x + deceleration * delta)

	# Jumping logic
	if is_on_floor():
		can_jump = true
		is_jumping = false
		jump_timer = 0.0

	if Input.is_action_just_pressed("ui_up") and can_jump:
		is_jumping = true
		can_jump = false
		velocity.y = jump_power

	if is_jumping and Input.is_action_pressed("ui_up") and jump_timer < max_jump_time:
		velocity.y = jump_power
		jump_timer += delta
	elif is_jumping:
		is_jumping = false

func apply_gravity(delta):
	# Apply gravity to the character's vertical velocity
	velocity.y += gravity * delta

	if is_on_floor() and not is_jumping:
		can_jump = true
		velocity.y = 0
	elif is_jumping:
		velocity.y += fall_acceleration * delta / 2

		# Increase jump height when holding the jump button
		if Input.is_action_pressed("ui_up"):
			velocity.y += extra_jump_power * delta

	else:
		velocity.y += fall_acceleration * delta

	# Limit the fall velocity to prevent it from becoming too fast
	velocity.y = min(velocity.y, max_fall_velocity)


