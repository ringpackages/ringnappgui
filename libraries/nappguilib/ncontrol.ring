/*
	NControl: the parent class of the controls
	The control is created by init() (or by the first call to handle() when the object
	is created without parentheses). Columns, rows and indexes start from 1.
*/

class NControl

	pObject = NULL

	# The layout cell that holds the control (set by NLayout.add())
	pCellLayout = NULL
	nCellCol = 0
	nCellRow = 0

	func init
		handle()
		return self

	func handle
		if isNull(pObject)
			pObject = createObject()
		ok
		return pObject

	func createObject
		raise("NAppGUI Error: the class " + classname(self) + " doesn't create a control")

	func layoutAdd pLayout, nCol, nRow
		raise("NAppGUI Error: the class " + classname(self) + " can't be added to a layout")

	func splitAdd pSplit
		# Add the control to a split view inside a panel
		pSplitLayout = layout_create(1, 1)
		layoutAdd(pSplitLayout, 1, 1)
		pSplitPanel = panel_create()
		panel_layout(pSplitPanel, pSplitLayout)
		splitview_panel(pSplit, pSplitPanel)

	func setCell pLayout, nCol, nRow
		pCellLayout = pLayout
		nCellCol = nCol
		nCellRow = nRow

	func cell
		if isNull(pCellLayout)
			raise("NAppGUI Error: add the control to a layout first")
		ok
		return layout_cell(pCellLayout, nCellCol - 1, nCellRow - 1)

	func setEnabled lEnabled
		cell_enabled(cell(), lEnabled)
		return self

	func setVisible lVisible
		cell_visible(cell(), lVisible)
		return self

	func setPadding nPadding
		cell_padding(cell(), nPadding)
		return self

	func setPadding4 nTop, nRight, nBottom, nLeft
		cell_padding4(cell(), nTop, nRight, nBottom, nLeft)
		return self

	func setTag nTag
		guicontrol_tag(handle(), nTag)
		return self

	func tag
		return guicontrol_get_tag(handle())
