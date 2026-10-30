/*
	NSplitView: two parts with a divider that the user can move
	new NSplitView(ekGUI_HORIZONTAL) puts the parts side by side,
	new NSplitView(ekGUI_VERTICAL) puts one part above the other.
*/

class NSplitView from NControl

	nOrientation = ekGUI_HORIZONTAL

	func init nSplitOrientation
		nOrientation = nSplitOrientation
		handle()
		return self

	func createObject
		# NAppGUI names the split by its divider: a vertical divider puts the parts side by side
		if nOrientation = ekGUI_VERTICAL
			return splitview_horizontal()
		ok
		return splitview_vertical()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_splitview(pLayout, handle(), nCol - 1, nRow - 1)

	func splitAdd pSplit
		splitview_split(pSplit, handle())

	func add oControl
		# Add the first part, then the second part (controls, panels, layouts or split views)
		oControl.splitAdd(handle())
		return self

	func setPosition nPosition
		# A value from 0 to 1 (the size of the first part)
		splitview_pos(handle(), nPosition)
		return self

	func setSize nWidth, nHeight
		splitview_size(handle(), s2df(nWidth, nHeight))
		return self
