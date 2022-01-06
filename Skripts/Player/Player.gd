extends KinematicBody2D

#Imports From Scene
onready var AnimSprite = $AnimatedSprite
onready var Weapon = $WeaponNode/Weapon
onready var AnimPlayer = $AnimationPlayer
onready var LifeUI = $Label
onready var MeleeBox = $Melee
onready var WeaponNode = $WeaponNode

#PlayerStats
var speed = 10
var jumpHeight = 460
var currentSpeed = Vector2()
var PlayerLifes = 3

#Weapon Stats
export(bool) var fireCooldown
var xSpeed = 100
export(int) var yValue

#Game Physics
var gravity = 400
var UpVector = Vector2(0, -1)


#test
export var on_floor = true

func _ready():
	LifeUI.text = "Lifes: " + str(PlayerLifes)
	randomize()
	fireCooldown = true

func _physics_process(delta):
	CheckLifes()
	MovementLeftandRight()
	PlayerGravity(delta)
	PlayerShoot()
	
	move_and_slide(currentSpeed, UpVector)
	on_floor = is_on_floor()
	PlayerJump()
	if is_on_ceiling():
		currentSpeed.y = 0
	#move_and_slide(currentSpeed, UpVector)



func MovementLeftandRight():
	if Input.is_action_pressed("Left"):
		currentSpeed.x += -1 * speed
		AnimSprite.flip_h = false
		MeleeBox.scale.x = -1
		WeaponNode.scale.x = -1
	
	if Input.is_action_pressed("Right"):
		currentSpeed.x += 1 * speed
		AnimSprite.flip_h = true
		MeleeBox.scale.x = 1
		WeaponNode.scale.x = 1
	
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
#AllowShot and LoadShot is switched due to unknown bug
func PlayerShoot():
	if Input.is_action_just_pressed("Shoot") and fireCooldown and !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left") and is_on_floor():
		AnimPlayer.play("AllowShot")
	
	if Input.is_action_just_released("Shoot") and fireCooldown and !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left") and is_on_floor():
		AnimPlayer.stop(true)
		fireCooldown = false
		AnimPlayer.play("LoadShot")
		Weapon.shoot(xSpeed, rand_range(yValue, yValue * -1), 90)
	
	if Input.is_action_just_pressed("PlayerMelee") and fireCooldown and !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left") and is_on_floor(): 
		AnimPlayer.play("PlayerMelee")
	
	if Input.is_action_just_released("PlayerMelee") and AnimPlayer.is_playing():
		AnimPlayer.stop(true)
		AnimPlayer.play(("DisableMelee"))

func AnimationController():
	if abs(currentSpeed.x) > 0.1:
		pass
		#AnimSprite.play("Run")
	else:
		AnimSprite.play("Idle")

func GetDamage(i):
	PlayerLifes -= i
	LifeUI.text = "Lifes: " + str(PlayerLifes)

func CheckLifes():
	if PlayerLifes <= 0:
		#queue_free()
		get_tree().reload_current_scene()

func _on_Area2D_body_entered(body):
	if !AnimPlayer.is_playing():
		AnimPlayer.play("GotDamaged")
		GetDamage(1)

#func wait_till_reload():

