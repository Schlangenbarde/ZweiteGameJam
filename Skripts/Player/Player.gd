extends KinematicBody2D

#Imports From Scene
onready var AnimSprite = $AnimatedSprite

#PlayerStats
var speed = 10
var jumpHeight = 400
var currentSpeed = Vector2()
var PlayerLifes = 3

#Game Physics
var gravity = 400
var UpVector = Vector2(0, -1)

func _ready():
	pass

func _physics_process(delta):
	MovementLeftandRight()
	PlayerGravity(delta)
	
	move_and_slide(currentSpeed, UpVector)
	PlayerJump()


func MovementLeftandRight():
	if Input.is_action_pressed("Left"):
		currentSpeed.x += -1 * speed
		AnimSprite.flip_h = false
	
	if Input.is_action_pressed("Right"):
		currentSpeed.x += 1 * speed
		AnimSprite.flip_h = true
	
	PlayerSpeedControll()

func PlayerGravity(time):
	if !is_on_floor():
		currentSpeed.y += gravity * time

func PlayerJump():
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		currentSpeed.y = -1 * jumpHeight
	
	if is_on_floor() and !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left"):
		currentSpeed.x = 0

func PlayerSpeedControll():
	if currentSpeed.x >= 150:
		currentSpeed.x = 150
	
	if currentSpeed.x <= -150:
		currentSpeed.x = -150

func AnimationController():
	if abs(currentSpeed.x) > 0.1:
		pass
		#AnimSprite.play("Run")
	else:
		AnimSprite.play("Idle")
