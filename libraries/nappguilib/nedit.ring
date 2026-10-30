/*
	NEdit: a single line text box
*/

class NEdit from NControl

	func init cText
		handle()
		edit_text(pObject, cText)
		return self

	func createObject
		return edit_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_edit(pLayout, handle(), nCol - 1, nRow - 1)

	func setText cText
		edit_text(handle(), cText)
		return self

	func text
		return edit_get_text(handle())

	func number
		return 0 + edit_get_text(handle())

	func setPlaceholder cText
		edit_phtext(handle(), cText)
		return self

	func setPassword lPassword
		edit_passmode(handle(), lPassword)
		return self

	func setEditable lEditable
		edit_editable(handle(), lEditable)
		return self

	func setAutoSelect lAutoSelect
		edit_autoselect(handle(), lAutoSelect)
		return self

	func setAlign nAlign
		edit_align(handle(), nAlign)
		return self

	func setTooltip cTooltip
		edit_tooltip(handle(), cTooltip)
		return self

	func setFont oFont
		edit_font(handle(), oFont.handle())
		return self

	func setColor nColor
		edit_color(handle(), nColor)
		return self

	func setBackColor nColor
		edit_bgcolor(handle(), nColor)
		return self

	func setFocusBackColor nColor
		edit_bgcolor_focus(handle(), nColor)
		return self

	func selectText nStart, nEnd
		# Character positions from 0; -1 for the end
		edit_select(handle(), nStart, nEnd)
		return self

	func copyText
		edit_copy(handle())
		return self

	func cutText
		edit_cut(handle())
		return self

	func pasteText
		edit_paste(handle())
		return self

	func setChangeEvent cCode
		# Runs when the text is changed and the user press Enter or leaves the box
		edit_OnChange(handle(), create_event(cCode))
		return self

	func setFilterEvent cCode
		# Runs at each key: read nappEvent().text() and use nappEvent().setFilterText()
		edit_OnFilter(handle(), create_event(cCode))
		return self

	func setFocusEvent cCode
		edit_OnFocus(handle(), create_event(cCode))
		return self
