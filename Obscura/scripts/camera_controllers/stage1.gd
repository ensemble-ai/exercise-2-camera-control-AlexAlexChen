class_name PositionLockCamera
extends CameraControllerBase

var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
var mesh_instance: MeshInstance3D = MeshInstance3D.new()

func _ready():
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)

func _process(delta):
	if target:
		position = target.global_position
	if draw_camera_logic:
		draw_logic()
	super(delta)
	
func draw_logic() -> void:
	# Clear previous drawings
	immediate_mesh.clear_surfaces()

	# Define cross size
	var cross_size: float = 5.0

	# Set material properties
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

	# Position mesh_instance at camera's position so it stays centered
	mesh_instance.global_transform = global_transform
