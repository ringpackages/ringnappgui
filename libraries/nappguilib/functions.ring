# Application

func nappRun cCreateCode
	# Start the application: cCreateCode (like "createGUI()") creates the windows
	lNAppRunning = True
	osmain_run(cCreateCode, "nappCleanup()", 0, "")

func nappRunTimer cCreateCode, nInterval
	# Start the application with a main loop that runs the timers each nInterval seconds
	if nInterval <= 0
		nInterval = NAPP_TIMER_INTERVAL
	ok
	lNAppRunning = True
	osmain_run(cCreateCode, "nappCleanup()", nInterval, "nappUpdate()")

func nappQuit
	# End the application (nappCleanup() destroys the windows and the resources)
	osapp_finish()

func nappTime
	# Seconds since the start of the main loop (nappRunTimer())
	return osmain_time()

func nappVersion
	return NAPPGUILIB_VERSION

# Timers (used with nappRunTimer())

func nappAddTimer nSeconds, cCode
	# Run cCode each nSeconds; returns the timer ID
	nNAppLastID++
	aNAppTimers + [nNAppLastID, nSeconds, osmain_time() + nSeconds, cCode, False]
	return nNAppLastID

func nappRemoveTimer nTimerID
	nTimerIndex = nappFindID(aNAppTimers, nTimerID)
	if nTimerIndex > 0
		del(aNAppTimers, nTimerIndex)
	ok

func nappSetUpdateEvent cCode
	# Run cCode at each frame of the main loop (animations and games)
	cNAppUpdateCode = cCode

func nappUpdate
	# Called by the main loop (nappRunTimer()), also while a modal window is open
	nNow = osmain_time()
	aDueTimers = []
	for aTimer in aNAppTimers
		# A timer that is still running (it opened a modal window) is skipped
		if nNow >= aTimer[3] and not aTimer[5]
			aDueTimers + aTimer[1]
		ok
	next
	for nTimerID in aDueTimers
		# The code of a timer can add or remove timers
		nTimerIndex = nappFindID(aNAppTimers, nTimerID)
		if nTimerIndex > 0
			aNAppTimers[nTimerIndex][3] = nNow + aNAppTimers[nTimerIndex][2]
			aNAppTimers[nTimerIndex][5] = True
			eval(aNAppTimers[nTimerIndex][4])
			nTimerIndex = nappFindID(aNAppTimers, nTimerID)
			if nTimerIndex > 0
				aNAppTimers[nTimerIndex][5] = False
			ok
		ok
	next
	if cNAppUpdateCode != "" and not lNAppUpdating
		lNAppUpdating = True
		eval(cNAppUpdateCode)
		lNAppUpdating = False
	ok

func nappCleanup
	# Called when the application ends: destroy the windows and the resources
	nCount = len(aNAppWindows)
	for nWindowIndex = nCount to 1 step -1
		if not isNull(aNAppWindows[nWindowIndex][2])
			window_destroy(aNAppWindows[nWindowIndex][2])
		ok
	next
	aNAppWindows = []
	nCount = len(aNAppResources)
	for nResourceIndex = nCount to 1 step -1
		nappDestroyResource(aNAppResources[nResourceIndex])
	next
	aNAppResources = []
	aNAppTables = []
	aNAppTimers = []
	cNAppUpdateCode = ""
	lNAppRunning = False
	clean_events()

# Events

func nappEvent
	# The current event as an NEvent object (call it inside an event)
	oNAppEvent = new NEvent
	oNAppEvent.loadParams()
	return oNAppEvent

func nappCanvas
	# An NCanvas object for the current draw event of an NView
	return nappEvent().canvas()

# Colors

func nappColor nRed, nGreen, nBlue
	return color_rgb(nRed, nGreen, nBlue)

func nappColorAlpha nRed, nGreen, nBlue, nAlpha
	return color_rgba(nRed, nGreen, nBlue, nAlpha)

func nappColorHex cHex
	# "#RRGGBB" to color
	return color_html(cHex)

func nappColorHSB nHue, nSaturation, nBrightness
	# Hue, saturation and brightness from 0 to 1
	return color_hsbf(nHue, nSaturation, nBrightness)

func nappColorToHex nColor
	return color_html_text(nColor)

func nappColorParts nColor
	# [nRed, nGreen, nBlue, nAlpha]
	return color_components(nColor)

# Dialogs

func nappMessage oParent, cTitle, cText
	# Show a message and wait for the OK button
	return nappDialog(oParent, cTitle, cText, ["OK"], False, "")

func nappConfirm oParent, cTitle, cText
	# Ask a question: returns True for Yes and False for No
	return nappDialog(oParent, cTitle, cText, ["Yes", "No"], False, "") = 1

func nappInput oParent, cTitle, cPrompt, cDefault
	# Ask for a text: returns the text, or NULL when the user cancels
	return nappDialog(oParent, cTitle, cPrompt, ["OK", "Cancel"], True, cDefault)

func nappDialog oParent, cTitle, cText, aButtons, lInput, cDefault
	nButtons = len(aButtons)
	oDialogLayout = new NLayout(1, 3)
	oDialogLabel = new NLabel(cText)
	oDialogLayout.add(oDialogLabel, 1, 1)
	oDialogEdit = NULL
	if lInput
		oDialogEdit = new NEdit(cDefault)
		oDialogLayout.add(oDialogEdit, 1, 2)
		oDialogLayout.setRowMargin(1, 10)
		oDialogLayout.setColumnWidth(1, 280)
	ok
	oButtonsLayout = new NLayout(nButtons, 1)
	aDialogButtons = []
	for nButtonIndex = 1 to nButtons
		oDialogButton = new NButton(aButtons[nButtonIndex])
		oDialogButton.setClickEvent("nappModalStop(" + nButtonIndex + ")")
		oButtonsLayout.add(oDialogButton, nButtonIndex, 1)
		if nButtonIndex < nButtons
			oButtonsLayout.setColumnMargin(nButtonIndex, 10)
		ok
		aDialogButtons + oDialogButton.handle()
	next
	oButtonsLayout.setHAlignCell(1, 1, ekRIGHT)
	oDialogLayout.add(oButtonsLayout, 1, 3)
	oDialogLayout.setHAlignCell(1, 3, ekRIGHT)
	oDialogLayout.setRowMargin(2, 15)
	oDialogLayout.setMargin(15)
	oDialogWindow = new NWindow(cTitle)
	oDialogWindow.setFlags(ekWINDOW_TITLE | ekWINDOW_CLOSE | ekWINDOW_ESC | ekWINDOW_RETURN)
	oDialogWindow.setLayout(oDialogLayout)
	window_defbutton(oDialogWindow.handle(), aDialogButtons[1])
	if isObject(oParent)
		aParentOrigin = oParent.origin()
		oDialogWindow.setOrigin(aParentOrigin[1] + 60, aParentOrigin[2] + 60)
	ok
	nResult = oDialogWindow.modal(oParent)
	# Enter selects the first button, Esc and the close button select the last button
	if nResult = NAPP_MODAL_CLOSED + ekGUI_CLOSE_INTRO
		nResult = 1
	but nResult > NAPP_MODAL_CLOSED
		nResult = nButtons
	ok
	vResult = nResult
	if lInput
		vResult = NULL
		if nResult = 1
			vResult = oDialogEdit.text()
		ok
	ok
	oDialogWindow.close()
	return vResult

func nappModalStop nValue
	# Close the active modal window: window.modal() returns nValue
	nCount = len(aNAppModalStack)
	if nCount = 0
		return
	ok
	nWindowIndex = nappFindID(aNAppWindows, aNAppModalStack[nCount])
	if nWindowIndex > 0
		window_stop_modal(aNAppWindows[nWindowIndex][2], nValue)
	ok

func nappOpenFile oParent, aTypes
	# File types like ["png", "jpg"]; returns the file name or NULL
	return comwin_open(nappWindowPointer(oParent), aTypes, "")

func nappSaveFile oParent, aTypes
	return comwin_save(nappWindowPointer(oParent), aTypes, "")

func nappChooseColor oParent, cTitle, nColor, cCode
	# Show the color selector; cCode runs when the color changes (use nappEvent().color())
	nX = 200 nY = 200
	if isObject(oParent)
		aParentOrigin = oParent.origin()
		nX = aParentOrigin[1] + 40
		nY = aParentOrigin[2] + 40
	ok
	comwin_choose_color(nappWindowPointer(oParent), cTitle, nX, nY, nColor, create_event(cCode))

func nappOpenURL cURL
	osapp_open_url(cURL)

# System information

func nappScreenSize
	pScreenSize = gui_resolution()
	return [s2df_width(pScreenSize), s2df_height(pScreenSize)]

func nappMousePosition
	pMousePos = gui_mouse_pos()
	return [v2df_x(pMousePos), v2df_y(pMousePos)]

func nappDarkMode
	return gui_dark_mode()

func nappFontFamilies
	return font_families_list()

func nappSystemFontFamily
	# The family of the system font (like "Segoe UI" on Windows)
	if cNAppSystemFamily = ""
		pFamilyFont = font_system(font_regular_size(), ekFNORMAL)
		cNAppSystemFamily = font_family(pFamilyFont)
		font_destroy(pFamilyFont)
	ok
	return cNAppSystemFamily

func nappMonospaceFontFamily
	if cNAppMonospaceFamily = ""
		pFamilyFont = font_monospace(font_regular_size(), ekFNORMAL)
		cNAppMonospaceFamily = font_family(pFamilyFont)
		font_destroy(pFamilyFont)
	ok
	return cNAppMonospaceFamily

func nappPlatform
	# ekWINDOWS, ekMACOS or ekLINUX
	return osbs_platform()

# Internal functions

func nappNewID
	nNAppLastID++
	return nNAppLastID

func nappFindID aRegistry, nRegistryID
	nCount = len(aRegistry)
	for nRegistryIndex = 1 to nCount
		if aRegistry[nRegistryIndex][1] = nRegistryID
			return nRegistryIndex
		ok
	next
	return 0

func nappWindowPointer oWindow
	if isObject(oWindow)
		return oWindow.handle()
	ok
	return NULL

func nappMainWindowPointer
	nCount = len(aNAppWindows)
	for nWindowIndex = 1 to nCount
		if aNAppWindows[nWindowIndex][5]
			return aNAppWindows[nWindowIndex][2]
		ok
	next
	return NULL

func nappAddResource cKind, pResource
	aNAppResources + [cKind, pResource]

func nappRemoveResource pResource
	nCount = len(aNAppResources)
	for nResourceIndex = 1 to nCount
		if ptrcmp(aNAppResources[nResourceIndex][2], pResource)
			del(aNAppResources, nResourceIndex)
			return True
		ok
	next
	return False

func nappDestroyResource aResource
	if isNull(aResource[2])
		return
	ok
	switch aResource[1]
	on "font"
		font_destroy(aResource[2])
	on "image"
		image_destroy(aResource[2])
	on "menu"
		menu_destroy(aResource[2])
	off

func nappCloseWindow nWindowID
	# Called when the user closes a window
	nWindowIndex = nappFindID(aNAppWindows, nWindowID)
	if nWindowIndex = 0
		return
	ok
	if aNAppWindows[nWindowIndex][4]
		# A modal window: stop the modal loop
		event_result_bool(False)
		window_stop_modal(aNAppWindows[nWindowIndex][2], NAPP_MODAL_CLOSED + nappEvent().origin())
		return
	ok
	if aNAppWindows[nWindowIndex][3] != ""
		eval(aNAppWindows[nWindowIndex][3])
		return
	ok
	if aNAppWindows[nWindowIndex][5]
		# Closing the main window ends the application
		nappQuit()
	ok

func nappTableData nTableID
	# The data of an NTableView (called by NAppGUI to draw the cells)
	nTableIndex = nappFindID(aNAppTables, nTableID)
	if nTableIndex = 0
		return
	ok
	aTableParams = event_params()
	switch aTableParams[:type]
	on ekGUI_EVENT_TBL_NROWS
		event_result_number(len(aNAppTables[nTableIndex][2]))
	on ekGUI_EVENT_TBL_CELL
		nCellRow = aTableParams[:row] + 1
		nCellCol = aTableParams[:col] + 1
		cCellText = ""
		if nCellRow <= len(aNAppTables[nTableIndex][2])
			aTableRow = aNAppTables[nTableIndex][2][nCellRow]
			if nCellCol <= len(aTableRow)
				cCellText = "" + aTableRow[nCellCol]
			ok
		ok
		nCellAlign = ekLEFT
		if nCellCol <= len(aNAppTables[nTableIndex][3])
			nCellAlign = aNAppTables[nTableIndex][3][nCellCol]
		ok
		event_result_cell(cCellText, nCellAlign)
	off
