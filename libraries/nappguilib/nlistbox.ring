/*
	NListBox: a list of items (with optional check boxes and multiple selection)
*/

class NListBox from NControl

	func createObject
		return listbox_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_listbox(pLayout, handle(), nCol - 1, nRow - 1)

	func addItem cText
		listbox_add_elem(handle(), cText, nullptr())
		return self

	func addImageItem cText, oImage
		listbox_add_elem(handle(), cText, oImage.handle())
		return self

	func addItems aItems
		for cItem in aItems
			addItem(cItem)
		next
		return self

	func setItem nIndex, cText
		listbox_set_elem(handle(), nIndex - 1, cText, nullptr())
		return self

	func clear
		listbox_clear(handle())
		return self

	func count
		return listbox_count(handle())

	func itemText nIndex
		return listbox_text(handle(), nIndex - 1)

	func setItemColor nIndex, nColor
		listbox_color(handle(), nIndex - 1, nColor)
		return self

	func setSelected nIndex
		# Select one item (0 removes the selection)
		nItems = listbox_count(handle())
		for nItem = 1 to nItems
			listbox_select(handle(), nItem - 1, nItem = nIndex)
		next
		return self

	func setItemSelected nIndex, lSelected
		listbox_select(handle(), nIndex - 1, lSelected)
		return self

	func isSelected nIndex
		return listbox_selected(handle(), nIndex - 1)

	func selected
		# The index of the first selected item (from 1), or 0
		nItems = listbox_count(handle())
		for nItem = 1 to nItems
			if listbox_selected(handle(), nItem - 1)
				return nItem
			ok
		next
		return 0

	func selectedItems
		# The indexes of the selected items
		aSelectedItems = []
		nItems = listbox_count(handle())
		for nItem = 1 to nItems
			if listbox_selected(handle(), nItem - 1)
				aSelectedItems + nItem
			ok
		next
		return aSelectedItems

	func setCheckBoxes lShow
		listbox_checkbox(handle(), lShow)
		return self

	func setChecked nIndex, lChecked
		listbox_check(handle(), nIndex - 1, lChecked)
		return self

	func isChecked nIndex
		return listbox_checked(handle(), nIndex - 1)

	func checkedItems
		aCheckedItems = []
		nItems = listbox_count(handle())
		for nItem = 1 to nItems
			if listbox_checked(handle(), nItem - 1)
				aCheckedItems + nItem
			ok
		next
		return aCheckedItems

	func setMultiSelect lMultiSelect
		listbox_multisel(handle(), lMultiSelect)
		return self

	func setSize nWidth, nHeight
		listbox_size(handle(), s2df(nWidth, nHeight))
		return self

	func setSelectEvent cCode
		listbox_OnSelect(handle(), create_event(cCode))
		return self
