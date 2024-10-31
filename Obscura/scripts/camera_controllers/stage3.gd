class_name PositionLockLerpCamera
extends CameraControllerBase

@export var follow_speed: float = 1.0
@export var catchup_speed: float = 5.0
@export var leash_distance: float = 10.0

var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
var mesh_instance: MeshInstance3D = MeshInstance3D.new()

func _ready():
	super._ready()
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)

func _process(delta):
	super._process(delta)
	
	if target:
		# 计算相机中心与目标之间的距离
		var distance_to_target = position.distance_to(target.global_position)
		
		# 如果距离超出 `leash_distance`，使用 `catchup_speed`；否则使用 `follow_speed`
		var speed: float
		if distance_to_target > leash_distance:
			speed = catchup_speed
		else:
			speed = follow_speed


		# 通过插值平滑地朝向 target
		position = position.lerp(target.global_position, speed * delta)

		# 保持相机的高度
		position.y = target.global_position.y + dist_above_target

	# 如果 draw_camera_logic 为真，绘制辅助的十字线
	if draw_camera_logic:
		draw_logic()

func draw_logic() -> void:
	immediate_mesh.clear_surfaces()
	
	var cross_size: float = 5.0
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# 绘制位于相机中心的十字线
	immediate_mesh.surface_add_vertex(Vector3(-cross_size, 0, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(cross_size, 0, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(0, -cross_size, 0.1))
	immediate_mesh.surface_add_vertex(Vector3(0, cross_size, 0.1))

	immediate_mesh.surface_end()

	# 将十字线的位置保持在相机中心
	mesh_instance.global_transform = global_transform
