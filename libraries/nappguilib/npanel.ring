/*
	NPanel: a container of layouts
	A panel can hold many layouts and show one of them (like pages)
*/

class NPanel from NControl

	nLayouts = 0

	func createObject
		return panel_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_panel(pLayout, handle(), nCol - 1, nRow - 1)

	func splitAdd pSplit
		splitview_panel(pSplit, handle())

	func setLayout oLayout
		addLayout(oLayout)
		return self

	func addLayout oLayout
		# Returns the index of the layout (from 1)
		panel_layout(handle(), oLayout.handle())
		nLayouts++
		return nLayouts

	func showLayout nIndex
		panel_visible_layout(handle(), nIndex - 1)
		panel_update(handle())
		return self

	func layoutCount
		return nLayouts

	func setSize nWidth, nHeight
		panel_size(handle(), s2df(nWidth, nHeight))
		return self

	func update
		panel_update(handle())
		return self
