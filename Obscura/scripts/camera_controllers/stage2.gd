class_name FrameAutoScrollCamera
extends CameraControllerBase

@export var top_left: Vector2 = Vector2(-10, 10)  # Top-left corner of the frame box
@export var bottom_right: Vector2 = Vector2(10, -10)  # Bottom-right corner of the frame box
@export var autoscroll_speed: Vector3 = Vector3(2, 2, 2)  # Units per second on x and z axes
@export var Target: Node3D

var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
var mesh_instance: MeshInstance3D = MeshInstance3D.new()

func _ready():
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)

func _process(delta):
	# Move the camera based on autoscroll_speed
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta

	# Ensure the target (player) remains within the frame boundaries
	if Target:
		var local_pos = Target.global_position - global_position
		var frame_width = bottom_right.x - top_left.x
		var frame_height = top_left.y - bottom_right.y

		# Check if target is outside the left or right boundary
		if local_pos.x < top_left.x:
			Target.global_position.x = global_position.x + top_left.x
		elif local_pos.x > bottom_right.x:
			Target.global_position.x = global_position.x + bottom_right.x

		# Check if target is outside the top or bottom boundary
		if local_pos.z < bottom_right.y:
			Target.global_position.z = global_position.z + bottom_right.y
		elif local_pos.z > top_left.y:
			Target.global_position.z = global_position.z + top_left.y

	# Draw the frame border box if draw_camera_logic is enabled
	if draw_camera_logic:
		draw_logic()
		_draw_frame_box()
		
func draw_logic() -> void:

	var material := ORMMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Calculate frame corners in 3D space
	var top_left_3d = Vector3(top_left.x, 0, top_left.y)
	var top_right_3d = Vector3(bottom_right.x, 0, top_left.y)
	var bottom_left_3d = Vector3(top_left.x, 0, bottom_right.y)
	var bottom_right_3d = Vector3(bottom_right.x, 0, bottom_right.y)

	# Draw the frame box
	immediate_mesh.surface_add_vertex(top_left_3d)
	immediate_mesh.surface_add_vertex(top_right_3d)

	immediate_mesh.surface_add_vertex(top_right_3d)
	immediate_mesh.surface_add_vertex(bottom_right_3d)

	immediate_mesh.surface_add_vertex(bottom_right_3d)
	immediate_mesh.surface_add_vertex(bottom_left_3d)

	immediate_mesh.surface_add_vertex(bottom_left_3d)
	immediate_mesh.surface_add_vertex(top_left_3d)

	immediate_mesh.surface_end()


# Draw the frame box for Stage 2
func _draw_frame_box() -> void:
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	var top_left_3d = Vector3(top_left.x, target.global_transform.origin.y, top_left.y)
	var top_right_3d = Vector3(bottom_right.x, target.global_transform.origin.y, top_left.y)
	var bottom_left_3d = Vector3(top_left.x, target.global_transform.origin.y, bottom_right.y)
	var bottom_right_3d = Vector3(bottom_right.x, target.global_transform.origin.y, bottom_right.y)

	# Draw frame border box
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(top_left_3d)
	immediate_mesh.surface_add_vertex(top_right_3d)

	immediate_mesh.surface_add_vertex(top_right_3d)
	immediate_mesh.surface_add_vertex(bottom_right_3d)

	immediate_mesh.surface_add_vertex(bottom_right_3d)
	immediate_mesh.surface_add_vertex(bottom_left_3d)

	immediate_mesh.surface_add_vertex(bottom_left_3d)
	immediate_mesh.surface_add_vertex(top_left_3d)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY

	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
