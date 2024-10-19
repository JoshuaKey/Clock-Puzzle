extends Node

enum TransitionType
{
	NONE
}

var _current_scene:Node = null
var _root:Window = null

func _ready() -> void:
	# Gets the Scene Tree Root
	# Aka the "Window" Node
	_root = get_tree().root
	
	# Gets the Last Child of the Scene Tree Root
	# This will be the "Main Scene" that is loaded from Project Settings
	_current_scene = _root.get_child(_root.get_child_count() - 1)

## Removes the current Scene Tree and 
## Adds a new Scene to the Scene Tree
func change_scene(scene_name:String, transition:TransitionType = TransitionType.NONE) -> void:
	# Defer the Change Scene Logic until the end of frame
	# to make sure we don't corrupt any data
	_deferred_change_scene.call_deferred(scene_name, transition)
	pass

func _deferred_change_scene(scene_name:String, _transition:TransitionType = TransitionType.NONE) -> void:
	# Free Current Scene
	_current_scene.free()
	
	# Load the new scene.
	var packed_scene:PackedScene = ResourceLoader.load(scene_name)
	_current_scene = packed_scene.instantiate()

	# Add it to the active scene, as child of root.
	_root.add_child(_current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = _current_scene
	pass
