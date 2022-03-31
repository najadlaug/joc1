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
		djump = 2
	
	if Input.is_action_just_pressed("ui_space") and djump > 0:
		velocity = Vector2.UP * jump_velocity
		djump -= 1
	
	if is_on_floor():
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("walk")

			
		elif velocity.x < 0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("walk")
			
		elif velocity.x == 0:
			$AnimatedSprite.animation = "idle"
			
	else:
		if abs(velocity.y) > 0.2:
			$AnimatedSprite.animation = "jump"
			
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_spikes1_body_entered(body):
	position = Vector2(40,500)

func _on_spikes3_body_entered(body):
	position = Vector2(40,500)
	
func _on_spikes2_body_entered(body):
	position = Vector2(40,500)

func _on_coin_body_entered(body):
	if GameManager.scene == 0:
		get_tree().change_scene("res://scenes/map2.tscn")
		GameManager.scene += 1
		$Camera2D.limit_right = 1550
		
	elif GameManager.scene == 1:
		get_tree().change_scene("res://scenes/win.tscn")

func mor():
	position = Vector2(40,500)
