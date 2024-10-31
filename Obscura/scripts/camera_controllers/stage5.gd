class_name SpeedupPushZoneCamera
extends CameraControllerBase

@export var push_ratio: float = 0.5
@export var pushbox_top_left: Vector2 = Vector2(-20, 20)
@export var pushbox_bottom_right: Vector2 = Vector2(20, -20)
@export var speedup_zone_top_left: Vector2 = Vector2(-10, 10)
@export var speedup_zone_bottom_right: Vector2 = Vector2(10, -10)

var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
var mesh_instance: MeshInstance3D = MeshInstance3D.new()

func _ready():
	super._ready()
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)

func _process(delta):
	super._process(delta)

	if target:
		var target_position_local = target.global_position - position
		var move_x = 0.0
		var move_z = 0.0

		# Check if the player is within the inner speedup zone
		if is_within_zone(target_position_local, speedup_zone_top_left, speedup_zone_bottom_right):
			# If the player is in the inner zone, the camera does not move
			return

		# Check the boundaries of the outer push zone
		if target_position_local.x < pushbox_top_left.x:
			move_x = target.velocity.x * push_ratio
		elif target_position_local.x > pushbox_bottom_right.x:
			move_x = target.velocity.x * push_ratio

		if target_position_local.z > pushbox_top_left.y:
			move_z = target.velocity.z * push_ratio
		elif target_position_local.z < pushbox_bottom_right.y:
			move_z = target.velocity.z * push_ratio

		# If the player is touching two edges (e.g., in a corner), the camera follows at full speed in both directions
		if abs(move_x) > 0 and abs(move_z) > 0:
			move_x = target.velocity.x
			move_z = target.velocity.z

		# Adjust the camera's position based on the calculated movement amount
		position.x += move_x * delta
		position.z += move_z * delta
		position.y = target.position.y + dist_above_target  # Maintain camera height

	# Draw the push zone border if needed
	if draw_camera_logic:
		draw_push_zone()

func is_within_zone(target_position: Vector3, zone_top_left: Vector2, zone_bottom_right: Vector2) -> bool:
	if zone_top_left.x < target_position.x and target_position.x < zone_bottom_right.x:
		if zone_bottom_right.y < target_position.z and target_position.z < zone_top_left.y:
			return true
	return false

func draw_push_zone() -> void:
	immediate_mesh.clear_surfaces()

	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.YELLOW

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw the outer push zone
	draw_box(pushbox_top_left, pushbox_bottom_right)

	# Draw the inner speedup zone
	draw_box(speedup_zone_top_left, speedup_zone_bottom_right)

	immediate_mesh.surface_end()

	# Align the drawn area with the camera's position
	mesh_instance.global_transform = global_transform

func draw_box(top_left: Vector2, bottom_right: Vector2) -> void:
	var z_height: float = position.y

	immediate_mesh.surface_add_vertex(Vector3(top_left.x, z_height, top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, z_height, top_left.y))

	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, z_height, top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, z_height, bottom_right.y))

	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, z_height, bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, z_height, bottom_right.y))

	immediate_mesh.surface_add_vertex(Vector3(top_left.x, z_height, bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, z_height, top_left.y))
