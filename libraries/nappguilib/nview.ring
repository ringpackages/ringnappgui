/*
	NView: a custom view for drawing (use nappCanvas() inside the draw event)
	The view gets the mouse and keyboard events (click it to get the keyboard focus)
*/

class NView from NControl

	func createObject
		return view_create()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_view(pLayout, handle(), nCol - 1, nRow - 1)

	func splitAdd pSplit
		splitview_view(pSplit, handle(), True)

	func setSize nWidth, nHeight
		view_size(handle(), s2df(nWidth, nHeight))
		return self

	func size
		return view_size_list(handle())

	func update
		# Draw the view again (the draw event runs)
		view_update(handle())
		return self

	func setContentSize nWidth, nHeight, nLineWidth, nLineHeight
		# For views with scroll bars (NScrollView)
		view_content_size(handle(), s2df(nWidth, nHeight), s2df(nLineWidth, nLineHeight))
		return self

	func viewport
		# [nX, nY, nWidth, nHeight] of the visible area
		return view_viewport_list(handle())

	func scrollTo nX, nY
		view_scroll_x(handle(), nX)
		view_scroll_y(handle(), nY)
		return self

	func setDrawEvent cCode
		view_OnDraw(handle(), create_event(cCode))
		return self

	func setOverlayEvent cCode
		view_OnOverlay(handle(), create_event(cCode))
		return self

	func setResizeEvent cCode
		view_OnSize(handle(), create_event(cCode))
		return self

	func setClickEvent cCode
		view_OnClick(handle(), create_event(cCode))
		return self

	func setMouseDownEvent cCode
		view_OnDown(handle(), create_event(cCode))
		return self

	func setMouseUpEvent cCode
		view_OnUp(handle(), create_event(cCode))
		return self

	func setMouseMoveEvent cCode
		view_OnMove(handle(), create_event(cCode))
		return self

	func setDragEvent cCode
		view_OnDrag(handle(), create_event(cCode))
		return self

	func setEnterEvent cCode
		view_OnEnter(handle(), create_event(cCode))
		return self

	func setExitEvent cCode
		view_OnExit(handle(), create_event(cCode))
		return self

	func setWheelEvent cCode
		view_OnWheel(handle(), create_event(cCode))
		return self

	func setKeyDownEvent cCode
		view_OnKeyDown(handle(), create_event(cCode))
		return self

	func setKeyUpEvent cCode
		view_OnKeyUp(handle(), create_event(cCode))
		return self

	func setFocusEvent cCode
		view_OnFocus(handle(), create_event(cCode))
		return self

	func setScrollEvent cCode
		view_OnScroll(handle(), create_event(cCode))
		return self
