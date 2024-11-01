class_name LeadCameraController
extends CameraControllerBase

@export var lead_speed: float = 2.0
@export var catchup_delay_duration: float = 0.01
@export var catchup_speed: float = 5.0
@export var leash_distance: float = 10.0

var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
var mesh_instance: MeshInstance3D = MeshInstance3D.new()

# Track the player's last position and the time since they stopped moving
var time_since_last_move: float = 0.0
var last_player_position: Vector3

func _ready():
	super._ready()
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)
	if target:
		last_player_position = target.global_position

func _process(delta):
	super._process(delta)

	if target:
		var player_position = target.global_position
		var movement_direction = (player_position - last_player_position).normalized()

		# Check if the player is moving
		if player_position.distance_to(last_player_position) > 0.1:
			last_player_position = player_position
			time_since_last_move = 0.0  # Reset delay timer
		else:
			time_since_last_move += delta  # Increase delay timer

		# Guide the camera in the player's movement direction, keeping a lead distance
		if player_position.distance_to(position) < leash_distance:
			position += movement_direction * lead_speed * delta
		elif time_since_last_move > catchup_delay_duration:
			# When the player stops moving and delay duration is exceeded, camera starts catching up
			position = position.lerp(player_position, catchup_speed * delta)

		# Maintain the camera's height
		position.y = player_position.y + dist_above_target

	# Draw the cross if enabled
	if draw_camera_logic:
		draw_logic()

func draw_logic() -> void:
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
