class_name LeadCameraController
extends CameraControllerBase

@export var lead_speed: float = 1.0
@export var catchup_delay_duration: float = 0.1
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
	immediate_mesh.clear_surfaces()

	var cross_size: float = 5.0
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw a cross centered on the camera
	immediate_mesh.surface_add_vertex(Vector3(-cross_size, 0, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(cross_size, 0, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(0, -cross_size, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(0, cross_size, 0.1))

	immediate_mesh.surface_end()

	# Keep the cross centered at the camera's position
	mesh_instance.global_transform = global_transform
