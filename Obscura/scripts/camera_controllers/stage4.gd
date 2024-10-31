class_name PositionLockLeadCamera
extends CameraControllerBase

# Exported fields for editor adjustment
@export var lead_speed: float = 2.0
@export var catchup_delay_duration: float = 1.0
@export var catchup_speed: float = 5.0
@export var leash_distance: float = 10.0

var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
var mesh_instance: MeshInstance3D = MeshInstance3D.new()

# Track time since the player last moved
var time_since_last_move: float = 0.0
var last_player_position: Vector3

func _ready():
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)
	if target:
		last_player_position = target.global_position
	position += Vector3(0.0, dist_above_target, 0.0)  # Set initial height

func _process(delta):
	if target:
		# Calculate the direction of the player's movement
		var player_position = target.global_position
		var movement_direction = (player_position - last_player_position).normalized()

		# Update last_player_position if the player is moving
		if player_position.distance_to(last_player_position) > 0.1:
			last_player_position = player_position
			time_since_last_move = 0.0  # Reset delay timer
		else:
			time_since_last_move += delta  # Increment delay timer

		# Lead camera in the direction of movement if the player is moving
		var lead_offset = movement_direction * lead_speed * delta
		var desired_position = player_position + lead_offset

		# Check if the player has stopped moving for longer than catchup_delay_duration
		if time_since_last_move > catchup_delay_duration:
			# Start catching up to the player with catchup_speed
			var distance = position.distance_to(player_position)
			if distance > leash_distance:
				desired_position = position + (player_position - position).normalized() * catchup_speed * delta

		# Update camera position manually, keeping height above target
		position.x = desired_position.x
		position.z = desired_position.z
		position.y = target.position.y + dist_above_target

	# Handle zoom and toggle draw logic from base class
	super._process(delta)

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
	
	# Draw the cross centered on the camera at a slight Z offset
	immediate_mesh.surface_add_vertex(Vector3(-cross_size, 0, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(cross_size, 0, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(0, -cross_size, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(0, cross_size, 0.1))

	immediate_mesh.surface_end()

	# Keep the cross centered on the camera
	mesh_instance.global_transform = global_transform
