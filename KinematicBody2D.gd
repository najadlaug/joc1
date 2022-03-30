extends KinematicBody2D

var base_velocity = 80
var jump_velocity = 250
var direction = Vector2.DOWN
var velocity = Vector2.ZERO
var gravity = Vector2.DOWN * 981
var djump = 2

func _physics_process(delta):
	velocity += gravity * delta
	velocity.x = 0
	
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT * base_velocity
		
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT * base_velocity 
	
	if is_on_floor():
		djump = 5
	
	if Input.is_action_just_pressed("ui_space") and djump > 0:
		velocity = Vector2.UP * jump_velocity
		djump -= 1
		
	if velocity.y != 0:
		$AnimatedSprite.animation = "jump"
	
	if is_on_floor():
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.animation = "walk"
			$AnimatedSprite.playing = true
			
		elif velocity.x < 0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.animation = "walk"
			$AnimatedSprite.playing = true
			
		elif velocity.x == 0:
			$AnimatedSprite.animation = "idle"
	
	velocity = move_and_slide(velocity, Vector2.UP)
