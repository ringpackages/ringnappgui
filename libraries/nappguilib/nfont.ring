/*
	NFont: a font (the fonts are destroyed when the application ends)
	new NFont("", 16, ekFBOLD) is the system font, new NFont("Consolas", 12, ekFNORMAL) uses
	a font family, and new NFont (without parentheses) is the regular system font.
*/

class NFont

	pObject = NULL
	cFamily = ""
	nSize = 0
	nStyle = ekFNORMAL

	func init cFontFamily, nFontSize, nFontStyle
		cFamily = cFontFamily
		nSize = nFontSize
		nStyle = nFontStyle
		handle()
		return self

	func handle
		if isNull(pObject)
			if nSize <= 0
				nSize = font_regular_size()
			ok
			if cFamily = ""
				pObject = font_system(nSize, nStyle)
			but lower(cFamily) = "monospace"
				pObject = font_monospace(nSize, nStyle)
			else
				pObject = font_create(cFamily, nSize, nStyle)
			ok
			nappAddResource("font", pObject)
		ok
		return pObject

	func family
		return font_family(handle())

	func size
		return font_size(handle())

	func style
		return font_style(handle())

	func height
		return font_height(handle())

	func textSize cText
		# [nWidth, nHeight] of the text (one line, or many lines)
		return font_text_size(handle(), cText, -1)

	func withStyle nFontStyle
		# A new NFont with another style
		oStyledFont = new NFont(cFamily, nSize, nFontStyle)
		return oStyledFont

	func destroy
		if isNull(pObject)
			return
		ok
		if nappRemoveResource(pObject)
			font_destroy(pObject)
		ok
		pObject = NULL
