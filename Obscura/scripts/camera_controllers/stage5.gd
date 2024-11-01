class_name SpeedupPushZoneCamera
extends CameraControllerBase

@export var push_ratio: float = 0.5
@export var pushbox_top_left: Vector2 = Vector2(-20, 20)
@export var pushbox_bottom_right: Vector2 = Vector2(20, -20)
@export var speedup_zone_top_left: Vector2 = Vector2(-10, 10)
@export var speedup_zone_bottom_right: Vector2 = Vector2(10, -10)

func _ready() -> void:
	super._ready()
	position = target.position

func _process(delta: float) -> void:
	super._process(delta)

	if target:
		var target_position_local = target.global_position - position
		var move_x = 0.0
		var move_z = 0.0

		# Check if the target is within the inner speedup zone, in which case the camera should not move
		if is_within_zone(target_position_local, speedup_zone_top_left, speedup_zone_bottom_right):
			# Target is within inner speedup zone; camera does not move
			return

		# Check if target is near the edges of the outer push zone and adjust camera movement accordingly
		if target_position_local.x < pushbox_top_left.x:
			move_x = target.velocity.x * push_ratio
		elif target_position_local.x > pushbox_bottom_right.x:
			move_x = target.velocity.x * push_ratio

		if target_position_local.z > pushbox_top_left.y:
			move_z = target.velocity.z * push_ratio
		elif target_position_local.z < pushbox_bottom_right.y:
			move_z = target.velocity.z * push_ratio

		# If the target is touching two edges (corner case), move camera at full speed in both x and z directions
		if abs(move_x) > 0 and abs(move_z) > 0:
			move_x = target.velocity.x
			move_z = target.velocity.z

		# Apply calculated movement to the camera
		position.x += move_x * delta
		position.z += move_z * delta
		position.y = target.position.y + dist_above_target  # Maintain the camera height

	# Draw the push zone if debug visualization is enabled
	if draw_camera_logic:
		draw_push_zone()

func is_within_zone(target_position: Vector3, zone_top_left: Vector2, zone_bottom_right: Vector2) -> bool:
	if zone_top_left.x < target_position.x and target_position.x < zone_bottom_right.x:
		if zone_bottom_right.y < target_position.z and target_position.z < zone_top_left.y:
			return true
	return false


func draw_push_zone() -> void:
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.YELLOW

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw outer push box
	draw_box(pushbox_top_left, pushbox_bottom_right, immediate_mesh)

	# Draw inner speedup zone box
	draw_box(speedup_zone_top_left, speedup_zone_bottom_right, immediate_mesh)

	immediate_mesh.surface_end()

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)

	# Position the mesh instance at the camera's current position
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Free the mesh after one frame update
	await get_tree().process_frame
	mesh_instance.queue_free()

func draw_box(top_left: Vector2, bottom_right: Vector2, immediate_mesh: ImmediateMesh) -> void:
	var z_height: float = position.y

	# Define corners for the box
	var top_left_3d = Vector3(top_left.x, z_height, top_left.y)
	var top_right_3d = Vector3(bottom_right.x, z_height, top_left.y)
	var bottom_left_3d = Vector3(top_left.x, z_height, bottom_right.y)
	var bottom_right_3d = Vector3(bottom_right.x, z_height, bottom_right.y)

	# Draw lines between corners to form the box
	immediate_mesh.surface_add_vertex(top_left_3d)
	immediate_mesh.surface_add_vertex(top_right_3d)

	immediate_mesh.surface_add_vertex(top_right_3d)
	immediate_mesh.surface_add_vertex(bottom_right_3d)

	immediate_mesh.surface_add_vertex(bottom_right_3d)
	immediate_mesh.surface_add_vertex(bottom_left_3d)

	immediate_mesh.surface_add_vertex(bottom_left_3d)
	immediate_mesh.surface_add_vertex(top_left_3d)
