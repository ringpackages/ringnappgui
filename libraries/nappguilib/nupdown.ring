/*
	NUpDown: two small arrow buttons (use nappEvent().isUp() inside the click event)
*/

class NUpDown from NControl

	func createObject
		return updown_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_updown(pLayout, handle(), nCol - 1, nRow - 1)

	func setTooltip cTooltip
		updown_tooltip(handle(), cTooltip)
		return self

	func setClickEvent cCode
		updown_OnClick(handle(), create_event(cCode))
		return self
