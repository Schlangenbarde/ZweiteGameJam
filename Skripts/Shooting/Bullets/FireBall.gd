extends RigidBody2D

#In Scene
onready var AnimPlayer = $AnimationPlayer

func _ready():
	AnimPlayer.play("BulletDestroy") 

func Destroy():
	self.queue_free()
