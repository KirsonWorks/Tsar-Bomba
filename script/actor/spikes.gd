tool
extends Sprite

export (int, 1, 30) var amount setget set_amount

func set_amount(value):
	if amount != value:
		var size = texture.get_size()
		region_rect = Rect2(0, 0, size.x * value, size.y)
		amount = value
		
		if has_node("trigger/collider"):
			update_shape()
	
		update()
	
func update_shape():
	var shape = $trigger/collider.shape as RectangleShape2D
	
	if shape:
		shape.extents = Vector2(region_rect.size.x / 2, region_rect.size.y / 2)
	
func _ready():
	$trigger/collider.shape = RectangleShape2D.new()
	update_shape()

func _on_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body is KinematicBody2D:
		if body.has_method("kill"):
			body.call("kill")
