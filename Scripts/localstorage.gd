extends Node
class_name LocalStorage

var _key: String = ""

func set_password(password: String):
	_key = password

func _xor(data: PackedByteArray, key: String) -> PackedByteArray:
	var key_bytes = key.to_utf8_buffer()
	var result = PackedByteArray()
	for i in data.size():
		result.append(data[i] ^ key_bytes[i % key_bytes.size()])
	return result

func set_item(file_name: String, data: Variant):
	var json = JSON.stringify(data)
	var plain_bytes = json.to_utf8_buffer()
	var encrypted = _xor(plain_bytes, _key)

	var file = FileAccess.open("user://%s.dat" % file_name, FileAccess.WRITE)
	file.store_buffer(encrypted)
	file.close()

func get_item(file_name: String) -> String:
	var path = "user://%s.dat" % file_name
	if not FileAccess.file_exists(path):
		return ''

	var file = FileAccess.open(path, FileAccess.READ)
	var encrypted = file.get_buffer(file.get_length())
	file.close()

	var decrypted = _xor(encrypted, _key)
	var json_string = decrypted.get_string_from_utf8()
	
	if json_string == null:
		return ''
	else:
		return json_string
