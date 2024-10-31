class_name PushZoneCamera
extends CameraControllerBase

@export var push_ratio: float = 0.5
@export var pushbox_top_left: Vector2 = Vector2(-20, 20)
@export var pushbox_bottom_right: Vector2 = Vector2(20, -20)
@export var speedup_zone_top_left: Vector2 = Vector2(-10, 10)
@export var speedup_zone_bottom_right: Vector2 = Vector2(10, -10)

var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
var mesh_instance: MeshInstance3D = MeshInstance3D.new()

func _ready():
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)
	position += Vector3(0.0, dist_above_target, 0.0)  # Set initial height above target

func _process(delta):
	if target:
		# Target's local position relative to the camera
		var target_position_local = target.global_position - position

		# Check if the target is within the speedup zone
		if is_within_zone(target_position_local, speedup_zone_top_left, speedup_zone_bottom_right):
			# Do not move the camera
			return

		# Check if the target is in the push zone
		var move_x = 0.0
		var move_z = 0.0

		if target_position_local.x < pushbox_top_left.x:
			move_x = -push_ratio
		elif target_position_local.x > pushbox_bottom_right.x:
			move_x = push_ratio

		if target_position_local.z > pushbox_top_left.y:
			move_z = push_ratio
		elif target_position_local.z < pushbox_bottom_right.y:
			move_z = -push_ratio

		# Apply movement based on push ratio
		position.x += move_x * delta * target.velocity.x
		position.z += move_z * delta * target.velocity.z
		position.y = target.position.y + dist_above_target  # Maintain height above target

	# Handle zoom and toggle draw logic from base class
	super._process(delta)

	# Draw the push zone if enabled
	if draw_camera_logic:
		draw_push_zone()

func is_within_zone(target_position: Vector3, zone_top_left: Vector2, zone_bottom_right: Vector2) -> bool:
	return (zone_top_left.x < target_position.x and target_position.x < zone_bottom_right.x) and \
		   (zone_bottom_right.y < target_position.z and target_position.z < zone_top_left.y)


func draw_push_zone() -> void:
	immediate_mesh.clear_surfaces()

	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.YELLOW

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw outer pushbox border
	draw_box(pushbox_top_left, pushbox_bottom_right)

	# Draw inner speedup zone border
	draw_box(speedup_zone_top_left, speedup_zone_bottom_right)

	immediate_mesh.surface_end()

	# Keep the push zone drawing centered on the camera
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
