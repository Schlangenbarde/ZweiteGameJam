extends KinematicBody2D

#Scene
onready var AnimSprite = $AnimatedSprite
onready var HitBox = $HitDetection
onready var AnimPlayer = $AnimationPlayer

#EnemyStats
var enemySpeed = 200
var jumpHeight = 400
var currentSpeed = Vector2()
var turn = false #bool for turning the sprite
var enemyLifes = 2 
#2 Lifes = Alive
#1 Lifes = stunned
#0 Lifes = dead

#GamePhysics
var gravity = 400
var UpVector = Vector2(0, -1)

func _ready():
	AnimPlayer.play("EnemyStartHitBox")

func _physics_process(delta):
	Movement()
	CheckEnemyLifes()
	move_and_slide(currentSpeed, UpVector)
	WallAndFall(delta)

func Movement():
	if is_on_floor():
		currentSpeed.x = enemySpeed
	else:
		currentSpeed.x = 0

func WallAndFall(time):
	if is_on_wall():
		enemySpeed *= -1
		turn = not turn
	
	AnimSprite.flip_h = turn
	
	if !is_on_floor():
		currentSpeed.y += gravity * time
	else:
		currentSpeed.y = 0

func GetDamage(i):
	enemyLifes -= i

func CheckEnemyLifes():
	if enemyLifes == 1.5:
		enemySpeed = 0
		AnimSprite.play("Stunned")
		AnimPlayer.play("EnemyStunned")
		enemyLifes -= 0.5
	

func Delete():
	self.queue_free()

func _on_HitDetection_body_entered(body):
	GetDamage(0.5)


func _on_HitDetection_area_entered(area):
	AnimPlayer.stop()
	AnimPlayer.play("EnemyEinsaugen")
	print("start")


func _on_HitDetection_area_exited(area):
	AnimPlayer.stop()
	print("ugigiugiugi")
