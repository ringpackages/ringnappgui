/*
	NSlider: a horizontal slider (the value is from 0 to 1, or inside a range set by setRange())
*/

class NSlider from NControl

	nMinimum = 0
	nMaximum = 1

	func createObject
		return slider_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_slider(pLayout, handle(), nCol - 1, nRow - 1)

	func setRange nMin, nMax
		nMinimum = nMin
		nMaximum = nMax
		return self

	func setValue nValue
		# A value inside the range (from 0 to 1 by default)
		if nMaximum = nMinimum
			return self
		ok
		slider_value(handle(), (nValue - nMinimum) / (nMaximum - nMinimum))
		return self

	func value
		return nMinimum + slider_get_value(handle()) * (nMaximum - nMinimum)

	func setSteps nSteps
		# Move the slider in steps (0 for continuous values)
		slider_steps(handle(), nSteps)
		return self

	func setTooltip cTooltip
		slider_tooltip(handle(), cTooltip)
		return self

	func setMoveEvent cCode
		slider_OnMoved(handle(), create_event(cCode))
		return self
