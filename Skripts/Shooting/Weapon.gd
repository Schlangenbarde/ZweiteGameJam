extends Position2D

export(PackedScene) var Bullet

func shoot(xValueSpeed, yValueSpeed):
	var new_shot = Bullet.instance();
	get_tree().get_root().add_child(new_shot);
	new_shot.global_position = global_position;
	
	new_shot.linear_velocity = self.global_transform.basis_xform(Vector2(xValueSpeed, yValueSpeed));
