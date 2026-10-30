/*
	NLayout: a grid of cells that places the controls (columns and rows start from 1)
*/

class NLayout from NControl

	nCols = 1
	nRows = 1

	func init nColumns, nRowsCount
		nCols = nColumns
		nRows = nRowsCount
		handle()
		return self

	func createObject
		return layout_create(nCols, nRows)

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_layout(pLayout, handle(), nCol - 1, nRow - 1)

	func add oControl, nCol, nRow
		# Put a control, a panel or another layout in a cell
		checkCell(nCol, nRow)
		oControl.layoutAdd(handle(), nCol, nRow)
		return self

	func checkCell nCol, nRow
		if nCol < 1 or nCol > nCols or nRow < 1 or nRow > nRows
			raise("NAppGUI Error: the cell (" + nCol + ", " + nRow + ") is outside the layout (" +
				nCols + " x " + nRows + ")")
		ok

	func columns
		return layout_ncols(handle())

	func rows
		return layout_nrows(handle())

	func insertColumn nCol
		layout_insert_col(handle(), nCol - 1)
		nCols++
		return self

	func insertRow nRow
		layout_insert_row(handle(), nRow - 1)
		nRows++
		return self

	func removeColumn nCol
		layout_remove_col(handle(), nCol - 1)
		nCols--
		return self

	func removeRow nRow
		layout_remove_row(handle(), nRow - 1)
		nRows--
		return self

	func setMargin nMargin
		layout_margin(handle(), nMargin)
		return self

	func setMargin4 nTop, nRight, nBottom, nLeft
		layout_margin4(handle(), nTop, nRight, nBottom, nLeft)
		return self

	func setColumnWidth nCol, nWidth
		layout_hsize(handle(), nCol - 1, nWidth)
		return self

	func setRowHeight nRow, nHeight
		layout_vsize(handle(), nRow - 1, nHeight)
		return self

	func setColumnMargin nCol, nMargin
		# The space after the column
		layout_hmargin(handle(), nCol - 1, nMargin)
		return self

	func setRowMargin nRow, nMargin
		# The space after the row
		layout_vmargin(handle(), nRow - 1, nMargin)
		return self

	func setColumnsMargin nMargin
		for nMarginCol = 1 to nCols - 1
			layout_hmargin(handle(), nMarginCol - 1, nMargin)
		next
		return self

	func setRowsMargin nMargin
		for nMarginRow = 1 to nRows - 1
			layout_vmargin(handle(), nMarginRow - 1, nMargin)
		next
		return self

	func expandColumn nCol
		# The column takes the extra width when the window is resized
		layout_hexpand(handle(), nCol - 1)
		return self

	func expandRow nRow
		layout_vexpand(handle(), nRow - 1)
		return self

	func setHAlignCell nCol, nRow, nAlign
		# ekLEFT, ekCENTER, ekRIGHT or ekJUSTIFY
		layout_halign(handle(), nCol - 1, nRow - 1, nAlign)
		return self

	func setVAlignCell nCol, nRow, nAlign
		# ekTOP, ekCENTER, ekBOTTOM or ekJUSTIFY
		layout_valign(handle(), nCol - 1, nRow - 1, nAlign)
		return self

	func showColumn nCol, lVisible
		layout_show_col(handle(), nCol - 1, lVisible)
		return self

	func showRow nRow, lVisible
		layout_show_row(handle(), nRow - 1, lVisible)
		return self

	func setCellEnabled nCol, nRow, lEnabled
		cell_enabled(layout_cell(handle(), nCol - 1, nRow - 1), lEnabled)
		return self

	func setTabStop nCol, nRow, lTabStop
		layout_tabstop(handle(), nCol - 1, nRow - 1, lTabStop)
		return self

	func setBackColor nColor
		layout_bgcolor(handle(), nColor)
		return self

	func setBorderColor nColor
		layout_skcolor(handle(), nColor)
		return self

	func update
		layout_update(handle())
		return self
