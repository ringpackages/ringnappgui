/*
	NEvent: the parameters of the current event (get it using nappEvent())
	Indexes, rows and columns start from 1.
*/

class NEvent

	aParams = []

	func loadParams
		aParams = event_params()
		return self

	func params
		# The list of [cName, vValue] pairs
		return aParams

	func param cName
		# The value of a parameter, or NULL
		nCount = len(aParams)
		for nParam = 1 to nCount
			if aParams[nParam][1] = cName
				return aParams[nParam][2]
			ok
		next
		return NULL

	func hasParam cName
		nCount = len(aParams)
		for nParam = 1 to nCount
			if aParams[nParam][1] = cName
				return True
			ok
		next
		return False

	func eventType
		# ekGUI_EVENT_BUTTON, ekGUI_EVENT_DRAW, ekGUI_EVENT_CLICK, ...
		return param("type")

	func sender
		return event_sender_object()

	# Mouse

	func x
		return param("x")

	func y
		return param("y")

	func button
		# ekGUI_MOUSE_LEFT, ekGUI_MOUSE_RIGHT or ekGUI_MOUSE_MIDDLE
		return param("button")

	func clicks
		# 1 for click, 2 for double click
		return param("count")

	func modifiers
		# ekMKEY_SHIFT, ekMKEY_CONTROL, ekMKEY_ALT (combined using |)
		return param("modifiers")

	func wheel
		# The vertical wheel movement
		return param("dy")

	# Keyboard

	func key
		# ekKEY_A, ekKEY_UP, ekKEY_RETURN, ...
		return param("key")

	# Controls

	func index
		# The item of a popup or a list box, the column of a table header (from 1)
		return param("index") + 1

	func state
		# ekGUI_ON, ekGUI_OFF or ekGUI_MIXED
		return param("state")

	func isChecked
		return param("state") = ekGUI_ON

	func isUp
		# Up/down buttons: True for the up button
		return param("index") = 0

	func text
		return param("text")

	func caretPos
		return param("cpos")

	func value
		# The position of a slider (from 0 to 1)
		return param("pos")

	func color
		return param("color")

	func focus
		return param("focus") = 1

	func origin
		# How a window is closed: ekGUI_CLOSE_ESC, ekGUI_CLOSE_INTRO, ekGUI_CLOSE_BUTTON, ...
		return param("origin")

	# Size and drawing

	func width
		return param("width")

	func height
		return param("height")

	func canvas
		# An NCanvas for the draw event
		oEventCanvas = new NCanvas
		oEventCanvas.setContext(param("ctx"), param("width"), param("height"))
		return oEventCanvas

	# Tables

	func row
		return param("row") + 1

	func column
		return param("col") + 1

	func rows
		# The selected rows (selection event)
		aEventRows = []
		for nEventRow in param("rows")
			aEventRows + (nEventRow + 1)
		next
		return aEventRows

	# Results

	func setResult lValue
		# For example, setResult(False) inside the close event keeps the window open
		event_result_bool(lValue)
		return self

	func setFilterText cText, nCaretPos
		# Change the text inside the filter event of NEdit and NCombo
		event_result_text(cText, nCaretPos)
		return self

	func setWindowSize nNewWidth, nNewHeight
		# Change the size inside the resize event of NWindow (while resizing)
		event_result_size(nNewWidth, nNewHeight)
		return self
