/*
	NLabel: a text label (a text with new lines creates a multi-line label)
*/

class NLabel from NControl

	cText = ""
	lMultiline = False
	lBoldFont = False
	lSizeText = False

	func init cLabelText
		cText = cLabelText
		lMultiline = substr(cLabelText, nl) > 0
		handle()
		label_text(pObject, cText)
		return self

	func createObject
		if lMultiline
			return label_multiline()
		ok
		return label_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_label(pLayout, handle(), nCol - 1, nRow - 1)

	func setText cLabelText
		cText = cLabelText
		label_text(handle(), cText)
		adjustSize()
		return self

	func text
		return cText

	func setSizeText cLabelText
		# The label size is computed using this text (for labels that change)
		lSizeText = True
		label_size_text(handle(), cLabelText)
		return self

	func setFont oFont
		label_font(handle(), oFont.handle())
		lBoldFont = (oFont.style() & ekFBOLD) != 0
		adjustSize()
		return self

	func adjustSize
		# NAppGUI measures some bold fonts (like Segoe UI) smaller than they are drawn
		if lBoldFont and not lSizeText and not lMultiline
			label_size_text(handle(), cText + "W")
		ok

	func setAlign nAlign
		label_align(handle(), nAlign)
		return self

	func setColor nColor
		label_color(handle(), nColor)
		return self

	func setBackColor nColor
		label_bgcolor(handle(), nColor)
		return self

	func setHoverColor nColor
		label_color_over(handle(), nColor)
		return self

	func setHoverBackColor nColor
		label_bgcolor_over(handle(), nColor)
		return self

	func setHoverStyle nFontStyle
		# ekFBOLD, ekFITALIC, ekFUNDERLINE, ... (combined using |)
		label_style_over(handle(), nFontStyle)
		return self

	func setClickEvent cCode
		label_OnClick(handle(), create_event(cCode))
		return self
