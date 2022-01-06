extends KinematicBody2D

#Imports From Scene
onready var AnimSprite = $AnimatedSprite
onready var Weapon = $Weapon
onready var AnimPlayer = $AnimationPlayer

#PlayerStats
var speed = 10
var jumpHeight = 400
var currentSpeed = Vector2()
var PlayerLifes = 3

#Weapon Stats
export(bool) var fireCooldown
var xSpeed = 100
export(int) var yValue

#Game Physics
var gravity = 400
var UpVector = Vector2(0, -1)

func _ready():
	fireCooldown = true

func _physics_process(delta):
	MovementLeftandRight()
	PlayerGravity(delta)
	PlayerShoot()
	
	move_and_slide(currentSpeed, UpVector)
	PlayerJump()
	#move_and_slide(currentSpeed, UpVector)


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
	elif currentSpeed.y > 0:
		currentSpeed.y = 0

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

func PlayerShoot():
	if Input.is_action_just_pressed("Shoot") and fireCooldown and !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left") and is_on_floor():
		AnimPlayer.play("LoadShot")
	
	if Input.is_action_just_released("Shoot") and fireCooldown and !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left") and is_on_floor():
		AnimPlayer.stop(true)
		fireCooldown = false
		AnimPlayer.play("AllowShot")
		for i in range(0,5):
			Weapon.shoot(xSpeed, rand_range(yValue, yValue * -1), 90)
	
	if Input.is_action_just_pressed("PlayerMelee") and fireCooldown and !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left") and is_on_floor(): 
		AnimPlayer.play("PlayerMelee")
	if Input.is_action_just_released("PlayerMelee") and AnimPlayer.is_playing():
		AnimPlayer.stop(true)
		AnimPlayer.play(("DisableMelee"))
		print("BREAK")

func AnimationController():
	if abs(currentSpeed.x) > 0.1:
		pass
		#AnimSprite.play("Run")
	else:
		AnimSprite.play("Idle")
