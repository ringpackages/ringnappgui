/*
	NCanvas: draw lines, shapes, text and images
	Get it using nappCanvas() inside the draw event of an NView, or use createBitmap()
	to draw an image (then toImage() returns an NImage).
	The drawing operations (nOp) are ekSTROKE, ekFILL, ekSKFILL and ekFILLSK.
*/

class NCanvas

	pContext = NULL
	nWidth = 0
	nHeight = 0
	lBitmap = False

	func setContext pCtx, nCanvasWidth, nCanvasHeight
		pContext = pCtx
		nWidth = nCanvasWidth
		nHeight = nCanvasHeight
		return self

	func handle
		if isNull(pContext)
			raise("NAppGUI Error: the canvas is empty (use nappCanvas() or createBitmap())")
		ok
		return pContext

	func width
		return nWidth

	func height
		return nHeight

	func createBitmap nBitmapWidth, nBitmapHeight
		pContext = dctx_bitmap(nBitmapWidth, nBitmapHeight, ekRGBA32)
		nWidth = nBitmapWidth
		nHeight = nBitmapHeight
		lBitmap = True
		return self

	func toImage
		# End drawing the bitmap and return it as an NImage
		if not lBitmap
			raise("NAppGUI Error: toImage() is used with createBitmap()")
		ok
		oCanvasImage = new NImage
		oCanvasImage.setPointer(dctx_image(pContext))
		pContext = NULL
		lBitmap = False
		return oCanvasImage

	func clear nColor
		draw_clear(handle(), nColor)
		return self

	func setAntialias lAntialias
		draw_antialias(handle(), lAntialias)
		return self

	# Lines

	func setLineColor nColor
		draw_line_color(handle(), nColor)
		return self

	func setLineWidth nLineWidth
		draw_line_width(handle(), nLineWidth)
		return self

	func setLineCap nCap
		# ekLCFLAT, ekLCSQUARE or ekLCROUND
		draw_line_cap(handle(), nCap)
		return self

	func setLineJoin nJoin
		# ekLJMITER, ekLJROUND or ekLJBEVEL
		draw_line_join(handle(), nJoin)
		return self

	func setLineDash aPattern
		# Like [6, 3] (dash and space lengths); [] for a solid line
		draw_line_dash_list(handle(), aPattern)
		return self

	func line nX1, nY1, nX2, nY2
		draw_line(handle(), nX1, nY1, nX2, nY2)
		return self

	func polyline lClosed, aPoints
		# aPoints: [[nX, nY], [nX, nY], ...]
		draw_polyline_list(handle(), lClosed, aPoints)
		return self

	func arc nX, nY, nRadius, nStart, nSweep
		# Angles in radians
		draw_arc(handle(), nX, nY, nRadius, nStart, nSweep)
		return self

	func bezier nX1, nY1, nCX1, nCY1, nCX2, nCY2, nX2, nY2
		draw_bezier(handle(), nX1, nY1, nCX1, nCY1, nCX2, nCY2, nX2, nY2)
		return self

	# Shapes

	func setFillColor nColor
		draw_fill_color(handle(), nColor)
		return self

	func setGradient aColors, aStops, nX1, nY1, nX2, nY2
		# A linear gradient: colors, stops from 0 to 1, and the gradient line
		draw_fill_linear_list(handle(), aColors, aStops, nX1, nY1, nX2, nY2)
		return self

	func rect nOp, nX, nY, nRectWidth, nRectHeight
		draw_rect(handle(), nOp, nX, nY, nRectWidth, nRectHeight)
		return self

	func fillRect nX, nY, nRectWidth, nRectHeight, nColor
		draw_fill_color(handle(), nColor)
		draw_rect(handle(), ekFILL, nX, nY, nRectWidth, nRectHeight)
		return self

	func roundRect nOp, nX, nY, nRectWidth, nRectHeight, nRadius
		draw_rndrect(handle(), nOp, nX, nY, nRectWidth, nRectHeight, nRadius)
		return self

	func circle nOp, nX, nY, nRadius
		draw_circle(handle(), nOp, nX, nY, nRadius)
		return self

	func fillCircle nX, nY, nRadius, nColor
		draw_fill_color(handle(), nColor)
		draw_circle(handle(), ekFILL, nX, nY, nRadius)
		return self

	func ellipse nOp, nX, nY, nRadiusX, nRadiusY
		draw_ellipse(handle(), nOp, nX, nY, nRadiusX, nRadiusY)
		return self

	func polygon nOp, aPoints
		draw_polygon_list(handle(), nOp, aPoints)
		return self

	# Text

	func setFont oFont
		draw_font(handle(), oFont.handle())
		return self

	func setTextColor nColor
		draw_text_color(handle(), nColor)
		return self

	func setTextAlign nHAlign, nVAlign
		# The position of text() is the left/center/right and top/center/bottom of the text
		draw_text_align(handle(), nHAlign, nVAlign)
		return self

	func setTextWidth nTextWidth
		# Wrap the text at this width (-1 for no wrapping)
		draw_text_width(handle(), nTextWidth)
		return self

	func setTextTrim nEllipsis
		# ekELLIPNONE, ekELLIPBEGIN, ekELLIPMIDDLE, ekELLIPEND or ekELLIPMLINE
		draw_text_trim(handle(), nEllipsis)
		return self

	func text cText, nX, nY
		draw_text(handle(), cText, nX, nY)
		return self

	func textSize cText
		# [nWidth, nHeight] using the current font
		return draw_text_size(handle(), cText, -1)

	# Images

	func image oImage, nX, nY
		draw_image(handle(), oImage.handle(), nX, nY)
		return self

	func setImageAlign nHAlign, nVAlign
		draw_image_align(handle(), nHAlign, nVAlign)
		return self
