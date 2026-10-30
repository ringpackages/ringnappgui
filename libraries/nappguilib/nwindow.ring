/*
	NWindow: a top level window
	The window is created when it's needed (so setFlags() can be called first).
	Closing the main window (the first window) ends the application, unless
	setCloseEvent() is used.
*/

class NWindow

	pObject = NULL
	nWindowID = 0
	cTitle = ""
	nFlags = ekWINDOW_STD
	pPanel = NULL

	func init cText
		cTitle = cText
		return self

	func handle
		if isNull(pObject)
			pObject = window_create(nFlags)
			window_title(pObject, cTitle)
			nWindowID = nappNewID()
			lMain = isNull(nappMainWindowPointer())
			aNAppWindows + [nWindowID, pObject, "", False, lMain, NULL]
			window_OnClose(pObject, create_event("nappCloseWindow(" + nWindowID + ")"))
		ok
		return pObject

	func setFlags nWindowFlags
		# ekWINDOW_STD, ekWINDOW_STDRES or a combination of ekWINDOW_* (before the window is used)
		if not isNull(pObject)
			raise("NAppGUI Error: call setFlags() before using the window")
		ok
		nFlags = nWindowFlags
		return self

	func setResizable lResizable
		if lResizable
			return setFlags(ekWINDOW_STDRES)
		ok
		return setFlags(ekWINDOW_STD)

	func setTitle cText
		cTitle = cText
		window_title(handle(), cText)
		return self

	func title
		return cTitle

	func setLayout oLayout
		pPanel = panel_create()
		panel_layout(pPanel, oLayout.handle())
		window_panel(handle(), pPanel)
		return self

	func setPanel oPanel
		pPanel = oPanel.handle()
		window_panel(handle(), pPanel)
		return self

	func show
		window_show(handle())
		return self

	func hide
		window_hide(handle())
		return self

	func close
		# Destroy the window
		if isNull(pObject)
			return
		ok
		nWindowIndex = nappFindID(aNAppWindows, nWindowID)
		if nWindowIndex > 0
			del(aNAppWindows, nWindowIndex)
		ok
		window_destroy(pObject)
		pObject = NULL

	func modal oParent
		# Show the window and wait until nappModalStop(nValue) is called; returns nValue
		pModalParent = nappWindowPointer(oParent)
		if isNull(pModalParent)
			pModalParent = nappMainWindowPointer()
		ok
		nWindowIndex = nappFindID(aNAppWindows, nWindowID)
		if nWindowIndex = 0
			handle()
			nWindowIndex = nappFindID(aNAppWindows, nWindowID)
		ok
		aNAppWindows[nWindowIndex][4] = True
		aNAppModalStack + nWindowID
		if isNull(pModalParent)
			pModalParent = nullptr()
		ok
		nModalResult = window_modal(handle(), pModalParent)
		del(aNAppModalStack, len(aNAppModalStack))
		nWindowIndex = nappFindID(aNAppWindows, nWindowID)
		if nWindowIndex > 0
			aNAppWindows[nWindowIndex][4] = False
		ok
		return nModalResult

	func setOrigin nX, nY
		window_origin(handle(), v2df(nX, nY))
		return self

	func origin
		pWindowPos = window_get_origin(handle())
		return [v2df_x(pWindowPos), v2df_y(pWindowPos)]

	func setSize nWidth, nHeight
		window_size(handle(), s2df(nWidth, nHeight))
		return self

	func size
		pWindowSize = window_get_size(handle())
		return [s2df_width(pWindowSize), s2df_height(pWindowSize)]

	func clientSize
		pWindowSize = window_get_client_size(handle())
		return [s2df_width(pWindowSize), s2df_height(pWindowSize)]

	func center
		# Put the window in the center of the screen
		aScreenSize = nappScreenSize()
		aWindowSize = size()
		setOrigin(floor((aScreenSize[1] - aWindowSize[1]) / 2), floor((aScreenSize[2] - aWindowSize[2]) / 2))
		return self

	func update
		window_update(handle())
		return self

	func setDefaultButton oButton
		window_defbutton(handle(), oButton.handle())
		return self

	func setFocus oControl
		window_focus(handle(), oControl.handle())
		return self

	func setMenuBar oMenu
		osapp_menubar(oMenu.handle(), handle())
		return self

	func setCursor nCursor
		# ekGUI_CURSOR_ARROW, ekGUI_CURSOR_HAND, ekGUI_CURSOR_IBEAM, ekGUI_CURSOR_CROSS, ...
		window_cursor(handle(), nCursor, nullptr(), 0, 0)
		return self

	func addHotKey nKey, nModifiers, cCode
		# nKey: ekKEY_*, nModifiers: ekMKEY_NONE, ekMKEY_SHIFT, ekMKEY_CONTROL, ekMKEY_ALT
		window_hotkey(handle(), nKey, nModifiers, create_event(cCode))
		return self

	func clearHotKeys
		window_clear_hotkeys(handle())
		return self

	func setCloseEvent cCode
		# cCode runs instead of the default action (use nappEvent().setResult(False) to keep the window)
		handle()
		nWindowIndex = nappFindID(aNAppWindows, nWindowID)
		aNAppWindows[nWindowIndex][3] = cCode
		return self

	func setResizeEvent cCode
		window_OnResize(handle(), create_event(cCode))
		return self

	func setMovedEvent cCode
		window_OnMoved(handle(), create_event(cCode))
		return self

	func isMainWindow
		handle()
		return aNAppWindows[nappFindID(aNAppWindows, nWindowID)][5]
