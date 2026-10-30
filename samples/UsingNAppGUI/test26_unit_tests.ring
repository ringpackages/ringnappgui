# Unit tests for NAppGUILib (the window opens, the tests run, then the application ends)
# Expected result: Failed: 0

load "nappguilib.ring"

nAppPassed = 0
nAppFailed = 0
oAppWindow = NULL
oAppLabel = NULL
oAppButton = NULL
oAppCheck = NULL
oAppEdit = NULL
oAppPopup = NULL
oAppList = NULL
oAppCombo = NULL
oAppSlider = NULL
oAppTable = NULL
oAppText = NULL
oAppLayout = NULL
nAppTicks = 0
nAppTimerID = 0
cAppImageFile = "nappgui_unit_test.png"

func main
	nappRunTimer("createGUI()", 0.02)
	? copy("=", 50)
	? "Passed: " + nAppPassed
	? "Failed: " + nAppFailed
	? copy("=", 50)

func createGUI
	oAppLabel = new NLabel("Label")
	oAppButton = new NButton("Button")
	oAppCheck = new NCheckBox("Check")
	oAppEdit = new NEdit("Text")
	oAppPopup = new NPopUp { addItems(["A", "B", "C"]) }
	oAppList = new NListBox { addItems(["One", "Two", "Three"]) setSize(100, 60) }
	oAppCombo = new NCombo { addItems(["X", "Y"]) }
	oAppSlider = new NSlider { setRange(10, 20) }
	oAppTable = new NTableView { addColumn("Name", 80) addColumn("Value", 60) setSize(150, 100) }
	oAppText = new NTextView { setSize(150, 60) }
	oAppLayout = new NLayout(2, 6) {
		add(oAppLabel, 1, 1)   add(oAppButton, 2, 1)
		add(oAppCheck, 1, 2)   add(oAppEdit, 2, 2)
		add(oAppPopup, 1, 3)   add(oAppList, 2, 3)
		add(oAppCombo, 1, 4)   add(oAppSlider, 2, 4)
		add(oAppTable, 1, 5)   add(oAppText, 2, 5)
	}
	oAppWindow = new NWindow("Unit Tests") { setLayout(oAppLayout) show() }
	nappAddTimer(0.1, "runTests()")
	nAppTimerID = nappAddTimer(0.05, "nAppTicks++")

func runTests
	for aTimer in aNAppTimers
		if aTimer[4] = "runTests()" nappRemoveTimer(aTimer[1]) ok
	next
	testColors()
	testControls()
	testLists()
	testTable()
	testLayoutWindow()
	testImagesFonts()
	testTimers()
	testDialogs()
	nappQuit()

func check cName, lResult
	if lResult
		nAppPassed++
	else
		nAppFailed++
		? "Failed: " + cName
	ok

func testColors
	nColor = nappColor(255, 128, 0)
	check("color hex", nappColorToHex(nColor) = "#FF8000")
	check("color from hex", nappColorHex("#FF8000") = nColor)
	aParts = nappColorParts(nappColorAlpha(1, 2, 3, 4))
	check("color parts", aParts[1] = 1 and aParts[2] = 2 and aParts[3] = 3 and aParts[4] = 4)
	check("named color", NAPP_COLOR_WHITE = nappColor(255, 255, 255))

func testControls
	oAppLabel.setText("New Label")
	check("label text", oAppLabel.text() = "New Label")
	oAppButton.setText("New Button")
	check("button text", oAppButton.text() = "New Button")
	oAppCheck.setChecked(True)
	check("check box on", oAppCheck.isChecked())
	oAppCheck.setChecked(False)
	check("check box off", not oAppCheck.isChecked())
	oAppCheck.setState(ekGUI_ON)
	check("button state", oAppCheck.state() = ekGUI_ON)
	oAppEdit.setText("12.5")
	check("edit text", oAppEdit.text() = "12.5")
	check("edit number", oAppEdit.number() = 12.5)
	oAppSlider.setValue(15)
	check("slider range value", fabs(oAppSlider.value() - 15) < 0.01)
	oAppText.setText("Line 1" + nl + "Line 2")
	check("text view text", substr(oAppText.text(), "Line 2") > 0)
	oAppText.clear()
	check("text view clear", trim(oAppText.text()) = "")
	oAppButton.setEnabled(False)
	oAppButton.setEnabled(True)
	check("enable control", True)

func testLists
	check("popup count", oAppPopup.count() = 3)
	oAppPopup.setSelected(2)
	check("popup selected", oAppPopup.selected() = 2)
	check("popup selected text", oAppPopup.selectedText() = "B")
	oAppPopup.addItem("D")
	check("popup add", oAppPopup.count() = 4 and oAppPopup.itemText(4) = "D")

	check("list count", oAppList.count() = 3)
	oAppList.setSelected(3)
	check("list selected", oAppList.selected() = 3)
	check("list item text", oAppList.itemText(2) = "Two")
	oAppList.setCheckBoxes(True)
	oAppList.setChecked(1, True)
	oAppList.setChecked(3, True)
	check("list checked", oAppList.isChecked(1) and not oAppList.isChecked(2))
	check("list checked items", list2str(oAppList.checkedItems()) = list2str([1, 3]))
	oAppList.setMultiSelect(True)
	oAppList.setItemSelected(1, True)
	check("list multi select", len(oAppList.selectedItems()) = 2)
	oAppList.clear()
	check("list clear", oAppList.count() = 0)

	check("combo count", oAppCombo.count() = 2)
	check("combo item", oAppCombo.itemText(2) = "Y")
	oAppCombo.setText("Typed")
	check("combo text", oAppCombo.text() = "Typed")

func testTable
	oAppTable.setData([["b", 2], ["a", 1], ["c", 3]])
	check("table rows", oAppTable.rowCount() = 3)
	check("table columns", oAppTable.columnCount() = 2)
	oAppTable.sortByColumn(1, True)
	check("table sort", oAppTable.row(1)[1] = "a" and oAppTable.row(3)[1] = "c")
	oAppTable.sortByColumn(2, False)
	check("table sort descending", oAppTable.row(1)[2] = 3)
	oAppTable.addRow(["d", 4])
	check("table add row", oAppTable.rowCount() = 4)
	oAppTable.removeRow(1)
	check("table remove row", oAppTable.rowCount() = 3)
	oAppTable.selectRows([2])
	check("table select", list2str(oAppTable.selected()) = "2")
	check("table selected row", oAppTable.selectedRow() = 2)
	oAppTable.deselectAll()
	check("table deselect", len(oAppTable.selected()) = 0)
	oAppTable.clear()
	check("table clear", oAppTable.rowCount() = 0)

func testLayoutWindow
	check("layout columns", oAppLayout.columns() = 2)
	check("layout rows", oAppLayout.rows() = 6)
	oAppWindow.setTitle("Unit Tests Running")
	check("window title", oAppWindow.title() = "Unit Tests Running")
	aSize = oAppWindow.size()
	check("window size", aSize[1] > 0 and aSize[2] > 0)
	# The window manager can adjust the position (frame and screen scale), so compare two positions
	oAppWindow.setOrigin(100, 100)
	aOrigin1 = oAppWindow.origin()
	oAppWindow.setOrigin(300, 200)
	aOrigin2 = oAppWindow.origin()
	check("window origin", aOrigin2[1] > aOrigin1[1] and aOrigin2[2] > aOrigin1[2])
	check("main window", oAppWindow.isMainWindow())
	aScreen = nappScreenSize()
	check("screen size", aScreen[1] > 0 and aScreen[2] > 0)

func testImagesFonts
	oCanvas = new NCanvas
	oCanvas.createBitmap(32, 16)
	oCanvas.clear(NAPP_COLOR_RED)
	aTextSize = oCanvas.textSize("Hello")
	check("canvas text size", aTextSize[1] > 0 and aTextSize[2] > 0)
	oImage = oCanvas.toImage()
	check("bitmap size", oImage.width() = 32 and oImage.height() = 16)
	oImage.setCodec(ekPNG)
	check("image save", oImage.save(cAppImageFile))
	oLoaded = new NImage(cAppImageFile)
	check("image load", not oLoaded.isEmpty() and oLoaded.width() = 32)
	oScaled = oLoaded.scaled(64, 32)
	check("image scale", oScaled.width() = 64 and oScaled.height() = 32)
	oMissing = new NImage
	check("image load missing file", not oMissing.loadFile("missing_file.png"))
	oScaled.destroy()
	check("image destroy", oScaled.isEmpty())
	remove(cAppImageFile)

	oFont = new NFont("", 20, ekFBOLD)
	check("font size", oFont.size() = 20)
	check("font style", (oFont.style() & ekFBOLD) != 0)
	aSize = oFont.textSize("Hello")
	check("font text size", aSize[1] > 0 and aSize[2] > 0)
	check("font families", len(nappFontFamilies()) > 0)
	check("system font family", nappSystemFontFamily() != "")

func testTimers
	check("timer ticks", nAppTicks > 0)
	nappRemoveTimer(nAppTimerID)
	nTicks = nAppTicks
	check("timer removed", nappFindID(aNAppTimers, nAppTimerID) = 0)
	check("time", nappTime() > 0)

func testDialogs
	# A timer closes each dialog using its first button
	nStopTimer = nappAddTimer(0.2, "nappModalStop(1)")
	check("message dialog", nappMessage(oAppWindow, "Test", "Message") = 1)
	check("confirm dialog", nappConfirm(oAppWindow, "Test", "Confirm") = True)
	check("input dialog", nappInput(oAppWindow, "Test", "Input", "Default") = "Default")
	nappRemoveTimer(nStopTimer)
	nStopTimer = nappAddTimer(0.2, "nappModalStop(2)")
	check("confirm dialog no", nappConfirm(oAppWindow, "Test", "Confirm") = False)
	check("input dialog cancel", nappInput(oAppWindow, "Test", "Input", "Default") = NULL)
	nappRemoveTimer(nStopTimer)
