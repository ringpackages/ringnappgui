/*
	NTableView: a table that shows a list of rows (each row is a list of values)
	The library gives the data to NAppGUI, so only the visible cells are drawn.
	Rows and columns start from 1.
*/

class NTableView from NControl

	nTableID = 0
	nColumns = 0

	func createObject
		pTable = tableview_create()
		nTableID = nappNewID()
		aNAppTables + [nTableID, [], []]
		tableview_OnData(pTable, create_event("nappTableData(" + nTableID + ")"))
		return pTable

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_tableview(pLayout, handle(), nCol - 1, nRow - 1)

	func registryIndex
		handle()
		return nappFindID(aNAppTables, nTableID)

	func addColumn cTitle, nWidth
		# Returns the column number (from 1)
		nColumnID = tableview_new_column_text(handle())
		tableview_header_title(handle(), nColumnID, cTitle)
		if nWidth > 0
			tableview_column_width(handle(), nColumnID, nWidth)
		ok
		nColumns++
		aNAppTables[registryIndex()][3] + ekLEFT
		return nColumns

	func columnCount
		return nColumns

	func setColumnAlign nCol, nAlign
		# The alignment of the cells and the title: ekLEFT, ekCENTER or ekRIGHT
		aNAppTables[registryIndex()][3][nCol] = nAlign
		tableview_header_align(handle(), nCol - 1, nAlign)
		tableview_update(handle())
		return self

	func setColumnWidth nCol, nWidth
		tableview_column_width(handle(), nCol - 1, nWidth)
		return self

	func setColumnLimits nCol, nMin, nMax
		tableview_column_limits(handle(), nCol - 1, nMin, nMax)
		return self

	func setColumnTitle nCol, cTitle
		tableview_header_title(handle(), nCol - 1, cTitle)
		return self

	func freezeColumns nCol
		# The columns from 1 to nCol don't scroll horizontally
		tableview_column_freeze(handle(), nCol - 1)
		return self

	func setData aRows
		aNAppTables[registryIndex()][2] = aRows
		tableview_update(handle())
		return self

	func data
		return aNAppTables[registryIndex()][2]

	func addRow aRow
		aNAppTables[registryIndex()][2] + aRow
		tableview_update(handle())
		return self

	func setRow nRow, aRow
		aNAppTables[registryIndex()][2][nRow] = aRow
		tableview_update(handle())
		return self

	func row nRow
		return aNAppTables[registryIndex()][2][nRow]

	func removeRow nRow
		del(aNAppTables[registryIndex()][2], nRow)
		tableview_update(handle())
		return self

	func rowCount
		return len(aNAppTables[registryIndex()][2])

	func clear
		aNAppTables[registryIndex()][2] = []
		tableview_update(handle())
		return self

	func sortByColumn nCol, lAscending
		# Sort the rows using the values of a column, and show the arrow in the title
		aSortedRows = sort(aNAppTables[registryIndex()][2], nCol)
		if not lAscending
			aSortedRows = reverse(aSortedRows)
		ok
		aNAppTables[registryIndex()][2] = aSortedRows
		for nIndicatorCol = 1 to nColumns
			tableview_header_indicator(handle(), nIndicatorCol - 1, ekINDNONE)
		next
		if lAscending
			tableview_header_indicator(handle(), nCol - 1, ekINDUP_ARROW)
		else
			tableview_header_indicator(handle(), nCol - 1, ekINDDOWN_ARROW)
		ok
		tableview_update(handle())
		return self

	func selected
		# The selected rows (from 1)
		aSelectedRows = []
		for nSelectedRow in tableview_selected_list(handle())
			aSelectedRows + (nSelectedRow + 1)
		next
		return aSelectedRows

	func selectedRow
		# The first selected row, or 0
		aSelectedRows = tableview_selected_list(handle())
		if len(aSelectedRows) = 0
			return 0
		ok
		return aSelectedRows[1] + 1

	func selectRows aRows
		aSelectRows = []
		for nSelectRow in aRows
			aSelectRows + (nSelectRow - 1)
		next
		tableview_select_list(handle(), aSelectRows)
		return self

	func deselectAll
		tableview_deselect_all(handle())
		return self

	func focusRow nRow
		# Scroll to the row
		tableview_focus_row(handle(), nRow - 1, ekCENTER)
		return self

	func focusedRow
		return tableview_get_focus_row(handle()) + 1

	func setMultiSelect lMultiSelect
		tableview_multisel(handle(), lMultiSelect, False)
		return self

	func setGrid lHorizontal, lVertical
		tableview_grid(handle(), lHorizontal, lVertical)
		return self

	func setHeaderVisible lVisible
		tableview_header_visible(handle(), lVisible)
		return self

	func setHeaderClickable lClickable
		tableview_header_clickable(handle(), lClickable)
		return self

	func setRowHeight nHeight
		tableview_row_height(handle(), nHeight)
		return self

	func setFont oFont
		tableview_font(handle(), oFont.handle())
		return self

	func setSize nWidth, nHeight
		tableview_size(handle(), s2df(nWidth, nHeight))
		return self

	func update
		tableview_update(handle())
		return self

	func setSelectEvent cCode
		tableview_OnSelect(handle(), create_event(cCode))
		return self

	func setRowClickEvent cCode
		tableview_OnRowClick(handle(), create_event(cCode))
		return self

	func setHeaderClickEvent cCode
		# Use nappEvent().index() to get the column
		tableview_header_clickable(handle(), True)
		tableview_OnHeaderClick(handle(), create_event(cCode))
		return self
