# A custom node for displaying REXPaint xp ANSI images.

tool
extends Sprite

export(String, FILE, "*.xp") var xp_file setget xp_file_set
export(Texture) var font_texture setget font_texture_set

var char_width = 0
var char_height = 0

func _redraw():
	if xp_file == null || font_texture == null:
		return
	
	# load data from the given font texture
	var font_data : Image = font_texture.get_data()
	char_width = font_data.get_width() / 16
	char_height = font_data.get_height() / 16
	
	font_data.lock()
	
	# unzip and parse the xp file
	var file = File.new()
	file.open(xp_file, File.READ)
	
	file.get_32() # xp version, skipping
	var layers_num = file.get_32()
	var chars_num_x = file.get_32()
	var chars_num_y = file.get_32()
	
	var image_width = chars_num_x * char_width
	var image_height = chars_num_y * char_height
	
	# generate a new image from the xp file using the font texture
	var new_image : Image = Image.new()
	new_image.create(image_width, image_height, true, font_data.get_format())
	new_image.lock()
	
	var color_rect : Image = Image.new()
	color_rect.create(char_width, char_height, true, font_data.get_format())
	
	for layer in range(layers_num):
		for tile_x in range(chars_num_x):
			for tile_y in range(chars_num_y):
				var char_code = file.get_32()
				var r = float(file.get_8()) / 255.0
				var g = float(file.get_8()) / 255.0
				var b = float(file.get_8()) / 255.0
				
				var b_r = float(file.get_8()) / 255.0
				var b_g = float(file.get_8()) / 255.0
				var b_b = float(file.get_8()) / 255.0
				
				var color = Color(r, g, b)
				var bg_color = Color(b_r, b_g, b_b)
				var src_rect = _get_char_rect(char_code)
				var tile_x_pos = tile_x * char_width
				var tile_y_pos = tile_y * char_height
				
				if char_code == 219:
					# current char is jus a solid square
					color_rect.fill(color)
					new_image.blit_rect(color_rect, Rect2(0, 0, char_width, char_height), Vector2(tile_x_pos, tile_y_pos))
				else:
					# apply background color
					color_rect.fill(bg_color)
					new_image.blit_rect(color_rect, Rect2(0, 0, char_width, char_height), Vector2(tile_x_pos, tile_y_pos))
					# and rest of the pixels
					var skip_char = color == bg_color || char_code == 32 || char_code == 0
					if(!skip_char):
						for pix_x in range(char_width):
							for pix_y in range(char_height):
								if font_data.get_pixel(src_rect.position.x + pix_x, src_rect.position.y + pix_y) != Color.black:
									new_image.set_pixel(tile_x_pos + pix_x, tile_y_pos + pix_y, color)

	new_image.unlock()
	# create a new texture using generated image
	var new_tex = ImageTexture.new()
	new_tex.create(image_width, image_height, font_data.get_format())
	new_tex.set_data(new_image)
	self.texture = new_tex
	texture.flags = 0

func _get_char_rect(char_code):
	var y_pos = floor(char_code / 16)
	var y = y_pos * char_width
	var x = (char_code - (y_pos * 16)) * char_width
	return Rect2(x, y, char_width, char_height)

func xp_file_set(value):
	xp_file = value
	_redraw()

func font_texture_set(value):
	font_texture = value
	_redraw()
