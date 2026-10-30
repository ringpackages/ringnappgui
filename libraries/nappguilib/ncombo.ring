/*
	NCombo: a text box with a list of items
*/

class NCombo from NControl

	func createObject
		return combo_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_combo(pLayout, handle(), nCol - 1, nRow - 1)

	func addItem cText
		combo_add_elem(handle(), cText, nullptr())
		return self

	func addItems aItems
		for cItem in aItems
			addItem(cItem)
		next
		return self

	func setItem nIndex, cText
		combo_set_elem(handle(), nIndex - 1, cText, nullptr())
		return self

	func insertItem nIndex, cText
		combo_ins_elem(handle(), nIndex - 1, cText, nullptr())
		return self

	func removeItem nIndex
		combo_del_elem(handle(), nIndex - 1)
		return self

	func count
		return combo_count(handle())

	func itemText nIndex
		return combo_get_text(handle(), nIndex - 1)

	func setText cText
		combo_text(handle(), cText)
		return self

	func text
		# The text of the box (combo_get_text() with an index outside the list)
		return combo_get_text(handle(), 0xFFFFFFFF)

	func setPlaceholder cText
		combo_phtext(handle(), cText)
		return self

	func setTooltip cTooltip
		combo_tooltip(handle(), cTooltip)
		return self

	func setColor nColor
		combo_color(handle(), nColor)
		return self

	func setBackColor nColor
		combo_bgcolor(handle(), nColor)
		return self

	func setChangeEvent cCode
		combo_OnChange(handle(), create_event(cCode))
		return self

	func setFilterEvent cCode
		combo_OnFilter(handle(), create_event(cCode))
		return self
