/*
	NImage: an image (PNG, JPG, BMP or GIF) loaded from a file or made by NCanvas
	The images are destroyed when the application ends.
*/

class NImage

	pObject = NULL

	func init cFileName
		loadFile(cFileName)
		return self

	func handle
		if isNull(pObject)
			raise("NAppGUI Error: the image is empty (use loadFile())")
		ok
		return pObject

	func loadFile cFileName
		# Returns True if the file is loaded
		pNewImage = image_load(cFileName)
		if isNull(pNewImage)
			return False
		ok
		setPointer(pNewImage)
		return True

	func setPointer pImage
		destroy()
		pObject = pImage
		nappAddResource("image", pObject)
		return self

	func isEmpty
		return isNull(pObject)

	func save cFileName
		# The format comes from the image codec (ekPNG by default for images made by NCanvas)
		return image_save(handle(), cFileName)

	func setCodec nCodec
		# ekJPG, ekPNG, ekBMP or ekGIF (used by save())
		image_codec(handle(), nCodec)
		return self

	func width
		return image_width(handle())

	func height
		return image_height(handle())

	func scaled nWidth, nHeight
		# A new NImage with another size
		oScaledImage = new NImage
		oScaledImage.setPointer(image_scale(handle(), nWidth, nHeight))
		return oScaledImage

	func trimmed nX, nY, nWidth, nHeight
		# A new NImage with a part of this image
		oTrimmedImage = new NImage
		oTrimmedImage.setPointer(image_trim(handle(), nX, nY, nWidth, nHeight))
		return oTrimmedImage

	func frames
		# The number of frames (animated GIF)
		return image_num_frames(handle())

	func destroy
		if isNull(pObject)
			return
		ok
		if nappRemoveResource(pObject)
			image_destroy(pObject)
		ok
		pObject = NULL
