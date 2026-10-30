/*
	NTextView: a multi-line text box (text with fonts, colors and paragraph styles)
	The text uses the system font (setFontFamily("monospace") for a monospace font)
*/

class NTextView from NControl

	func createObject
		pTextView = textview_create()
		textview_family(pTextView, nappSystemFontFamily())
		textview_fsize(pTextView, font_regular_size())
		return pTextView

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_textview(pLayout, handle(), nCol - 1, nRow - 1)

	func splitAdd pSplit
		splitview_text(pSplit, handle(), True)

	func write cText
		# Add the text at the end, using the current font, color and paragraph style
		textview_writef(handle(), cText)
		return self

	func writeLine cText
		textview_writef(handle(), cText + nl)
		return self

	func clear
		textview_clear(handle())
		return self

	func setText cText
		textview_clear(handle())
		textview_writef(handle(), cText)
		return self

	func text
		return textview_get_text(handle())

	func setEditable lEditable
		textview_editable(handle(), lEditable)
		return self

	func setFontFamily cFamily
		if lower(cFamily) = "monospace"
			cFamily = nappMonospaceFontFamily()
		ok
		textview_family(handle(), cFamily)
		return self

	func setFontSize nSize
		textview_fsize(handle(), nSize)
		return self

	func setFontStyle nStyle
		# ekFNORMAL, ekFBOLD, ekFITALIC, ekFUNDERLINE, ekFSTRIKEOUT (combined using |)
		textview_fstyle(handle(), nStyle)
		return self

	func setColor nColor
		textview_color(handle(), nColor)
		return self

	func setBackColor nColor
		# The background of the next text
		textview_bgcolor(handle(), nColor)
		return self

	func setPageColor nColor
		textview_pgcolor(handle(), nColor)
		return self

	func setAlign nAlign
		textview_halign(handle(), nAlign)
		return self

	func setLineSpacing nScale
		textview_lspacing(handle(), nScale)
		return self

	func setParagraphSpace nBefore, nAfter
		textview_bfspace(handle(), nBefore)
		textview_afspace(handle(), nAfter)
		return self

	func setSize nWidth, nHeight
		textview_size(handle(), s2df(nWidth, nHeight))
		return self

	func setScrollVisible lHorizontal, lVertical
		textview_scroll_visible(handle(), lHorizontal, lVertical)
		return self

	func scrollToCaret
		textview_scroll_caret(handle())
		return self

	func selectText nStart, nEnd
		textview_select(handle(), nStart, nEnd)
		return self

	func copyText
		textview_copy(handle())
		return self

	func cutText
		textview_cut(handle())
		return self

	func pasteText
		textview_paste(handle())
		return self

	func setFilterEvent cCode
		textview_OnFilter(handle(), create_event(cCode))
		return self

	func setFocusEvent cCode
		textview_OnFocus(handle(), create_event(cCode))
		return self
