/*
	NImageView: shows an image
*/

class NImageView from NControl

	func createObject
		return imageview_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_imageview(pLayout, handle(), nCol - 1, nRow - 1)

	func setImage oImage
		imageview_image(handle(), oImage.handle())
		return self

	func setScale nScale
		# ekGUI_SCALE_AUTO, ekGUI_SCALE_NONE, ekGUI_SCALE_ASPECT or ekGUI_SCALE_ASPECTDW
		imageview_scale(handle(), nScale)
		return self

	func setSize nWidth, nHeight
		imageview_size(handle(), s2df(nWidth, nHeight))
		return self

	func setClickEvent cCode
		imageview_OnClick(handle(), create_event(cCode))
		return self
