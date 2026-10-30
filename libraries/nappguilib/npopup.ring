/*
	NPopUp: a drop-down list (select one item)
*/

class NPopUp from NControl

	func createObject
		return popup_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_popup(pLayout, handle(), nCol - 1, nRow - 1)

	func addItem cText
		popup_add_elem(handle(), cText, nullptr())
		return self

	func addImageItem cText, oImage
		popup_add_elem(handle(), cText, oImage.handle())
		return self

	func addItems aItems
		for cItem in aItems
			addItem(cItem)
		next
		return self

	func setItem nIndex, cText
		popup_set_elem(handle(), nIndex - 1, cText, nullptr())
		return self

	func clear
		popup_clear(handle())
		return self

	func count
		return popup_count(handle())

	func itemText nIndex
		return popup_get_text(handle(), nIndex - 1)

	func setSelected nIndex
		popup_selected(handle(), nIndex - 1)
		return self

	func selected
		# The index of the selected item (from 1), or 0
		nSelected = popup_get_selected(handle())
		if nSelected >= popup_count(handle())
			return 0
		ok
		return nSelected + 1

	func selectedText
		nSelected = selected()
		if nSelected = 0
			return ""
		ok
		return itemText(nSelected)

	func setListHeight nItems
		popup_list_height(handle(), nItems)
		return self

	func setTooltip cTooltip
		popup_tooltip(handle(), cTooltip)
		return self

	func setSelectEvent cCode
		popup_OnSelect(handle(), create_event(cCode))
		return self
