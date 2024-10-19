class_name SaveSystem

## Loads the Resource at the given Path
## [br][br]
## Returns NULL if Resource Path does not exist.
##[br]NOTE: Result should be cast to desired type using AS
## to ensure type safety
##[br]NOTE: that Path must be in the User directory: "user://"
static func load_resource(path:String) -> Resource:
	if ResourceLoader.exists(path):
		return load(path)
	return null

## Saves the given Resources to the given Path
## [br][br]
## Saves the Resource using ResourceSaver singleton
## [br]NOTE: that Path must be in the User directory: "user://"
## [br]NOTE: that Path must use the ".tres" file type, otherwise saving will fail
static func save_resource(path:String, data:Resource) -> void:
	ResourceSaver.save(data, path)

# Ways to save and Load:

# - Custom Logic
#	- Uses FileAccess and Custom Logic
#	- Custom Format
#	- Plaintext or Encrypted
#	- Data in any Format
#	- Advanced

# - JSON
#	- Uses FileAccess and JSON
#	- JSON Format
#	- Plaintext
#	- Requires Data in Dictionary structure
#	- Simple but Tedious

# - Configs 
#	- Uses ConfigFiles
#	- INI Format
#	- Plaintext or Encrypted
#	- Requires Data in Dictionary structure
#	- Simple but Tedious

# - Resources
#	- Uses Resource Saver / Loader
#	- Resource Format (.tres)
#	- Plaintext
#	- Requires Data in Resource class
#	- Simple

# - Custom Resource Format Saver / Loader
#	- Uses Resource Saver / Loader and Custom Logic
#	- Custom Format (.tres)
#	- Plaintext or Encrypted
#	- Requires Data in Resource class
#	- Advanced
