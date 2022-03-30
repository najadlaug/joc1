extends RigidBody2D

# Default Character Properties (Should be overwritten)
var acceleration = 10000
var top_move_speed = 200
var top_jump_speed = 400

# Movement Vars
var directional_force = Vector2()
const DIRECTION = {
	ZERO = Vector2(0, 0),
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0),
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1)
}

func _integrate_forces(state):
	# Final force
	var final_force = Vector2()
	
	# We are not moving when you are not changing the direction
	directional_force = DIRECTION.ZERO
	
	# Apply force on character
	apply_force(state)
	
	# Get movement velocity
	final_force = state.get_linear_velocity() + (directional_force * acceleration)
	
	# Prevent ourselves from exceeding top speeds
	if(final_force.x > top_move_speed):
		final_force.x = top_move_speed
	elif(final_force.x < -top_move_speed):
		final_force.x = -top_move_speed
	# Prevent jumping too fast / falling too fast
	if(final_force.y > top_jump_speed):
		final_force.y = top_jump_speed
	elif(final_force.y < -top_jump_speed):
		final_force.y = -top_jump_speed
	
	# Add force
	state.set_linear_velocity(final_force)

# Grounded?
var grounded = false 

# Jumping
var can_jump = false
var jump_time = 0
const TOP_JUMP_TIME = 0.1 # in seconds

# Start
func _ready():
	# Set player properties
	acceleration = 1000
	top_move_speed = 200
	top_jump_speed = 400

# Apply force
func apply_force(state):
	# Move Left
	if(Input.is_action_pressed("ui_left")):
		directional_force += DIRECTION.LEFT
	
	# Move Right
	if(Input.is_action_pressed("ui_right")):
		directional_force += DIRECTION.RIGHT
	
	# Jump
	if(Input.is_action_pressed("ui_select") && jump_time < TOP_JUMP_TIME && can_jump):
		directional_force += DIRECTION.UP
		jump_time += state.get_step()
	elif(Input.is_action_just_released("ui_select")):
		can_jump = false # Prevents the player from jumping more than once while in air
	
	# While on the ground
	if(grounded):
		can_jump = true
		jump_time = 0


# Enter Ground
func _on_ground_check_body_enter( body ):
	# Get groups
	var groups = body.get_groups()
	
	# If we are on a solid ground
	if(groups.has("solid")):
		grounded = true


# Exit Ground
func _on_ground_check_body_exit( body ):
	# Get groups
	var groups = body.get_groups()
	
	# If we are on a solid ground
	if(groups.has("solid")):
		grounded = false

