/*
	NProgress: a progress bar (the value is from 0 to 1)
*/

class NProgress from NControl

	func createObject
		return progress_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_progress(pLayout, handle(), nCol - 1, nRow - 1)

	func setValue nValue
		progress_value(handle(), nValue)
		return self

	func setUndefined lRunning
		# An animated bar for tasks without a known length
		progress_undefined(handle(), lRunning)
		return self
