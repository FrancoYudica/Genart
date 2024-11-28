class_name ImageUtils extends RefCounted

static func create_monochromatic_image(
	width: int,
	height: int,
	color: Color
) -> Image:
	var img = Image.create(
		width,
		height,
		false, 
		Image.FORMAT_RGBA8)
	
	img.fill(color)
	return img
