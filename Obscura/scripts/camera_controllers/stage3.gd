class_name PositionLockLerpCamera
extends CameraControllerBase

@export var follow_speed: float = 100.0
@export var catchup_speed: float = 20.0
@export var leash_distance: float = 5.0


func _ready() -> void:
	super()
	current = false
	draw_camera_logic = true
	set_process(true)

func _process(delta: float) -> void:
	if !current:
		return
	if not target:
		return

	var target_position = target.global_position
	var camera_position = global_position

	# Calculate the distance between the camera and the target
	var distance = camera_position.distance_to(target_position)

	# If the distance is greater than the leash distance, move the camera
	if distance > leash_distance:
		# Calculate direction from camera to target
		var direction = (target_position - camera_position).normalized()

		# Determine speed: follow_speed if target is moving, otherwise catchup_speed
		var speed = follow_speed if target.get_velocity().length() > 0 else catchup_speed

		# Update camera position using lerp to smoothly move towards target
		var new_position = camera_position.lerp(target_position, speed * delta / distance)
		global_position = new_position

	# Draw a 5 by 5 unit cross in the center of the screen if draw_camera_logic is true
	if draw_camera_logic:
		_draw_center_cross()
		
	super(delta)

func _draw_center_cross() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -10 / 2 + 0.28
	var right:float = 10 / 2 + 0.30
	var top:float = 0.01
	var bottom:float = -0.01

	
	# Horizontal line
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()
	
	
	var left_v:float = 0
	var right_v:float = 0
	var top_v:float = 5
	var bottom_v:float = -5
	
	# Vertical line
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right_v, 0, top_v))
	immediate_mesh.surface_add_vertex(Vector3(right_v, 0, bottom_v))
	
	immediate_mesh.surface_add_vertex(Vector3(right_v, 0, bottom_v))
	immediate_mesh.surface_add_vertex(Vector3(left_v, 0, bottom_v))
	
	immediate_mesh.surface_add_vertex(Vector3(left_v, 0, bottom_v))
	immediate_mesh.surface_add_vertex(Vector3(left_v, 0, top_v))
	
	immediate_mesh.surface_add_vertex(Vector3(left_v, 0, top_v))
	immediate_mesh.surface_add_vertex(Vector3(right_v, 0, top_v))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
