# Menus: a menu bar with sub menus, keyboard shortcuts, check items and a popup menu

load "nappguilib.ring"

oAppWindow = NULL
oAppText = NULL
oAppWrapItem = NULL
oAppPopupMenu = NULL
lAppWrap = False

func main
	nappRun("createGUI()")

func createGUI
	oAppText = new NTextView { setSize(460, 260) }
	oAppText.writeLine("Use the menus, the shortcuts (Ctrl+N, Ctrl+O, Ctrl+Q)")
	oAppText.writeLine("or right click the box below to show a popup menu.")

	oArea = new NView {
		setSize(460, 60)
		setDrawEvent("drawArea()")
		setMouseUpEvent("areaClick()")
	}

	oLayout = new NLayout(1, 2) {
		add(oAppText, 1, 1)
		add(oArea, 1, 2)
		setRowMargin(1, 5)
		setMargin(5)
		expandRow(1)
	}

	oAppWindow = new NWindow("Menus") { setResizable(True) setLayout(oLayout) }
	oAppWindow.setMenuBar(createMenuBar())
	oAppWindow.show()
	oAppPopupMenu = createPopupMenu()

func createMenuBar
	# File menu
	oRecent = new NMenu {
		add(new NMenuItem("file1.txt") { setClickEvent("log('Recent: file1.txt')") })
		add(new NMenuItem("file2.txt") { setClickEvent("log('Recent: file2.txt')") })
	}
	oFile = new NMenu {
		add(new NMenuItem("New") { setKey(ekKEY_N, ekMKEY_CONTROL) setClickEvent("log('New')") })
		add(new NMenuItem("Open...") { setKey(ekKEY_O, ekMKEY_CONTROL) setClickEvent("openFile()") })
		add(new NMenuItem("Open Recent") { setSubMenu(oRecent) })
		addSeparator()
		add(new NMenuItem("Exit") { setKey(ekKEY_Q, ekMKEY_CONTROL) setClickEvent("nappQuit()") })
	}

	# View menu with a check item and a disabled item
	oAppWrapItem = new NMenuItem("Word Wrap") { setClickEvent("toggleWrap()") }
	oView = new NMenu {
		add(oAppWrapItem)
		add(new NMenuItem("Disabled Item") { setEnabled(False) })
	}

	# Help menu
	oHelp = new NMenu {
		add(new NMenuItem("About") { setClickEvent("nappMessage(oAppWindow, 'About', 'NAppGUI menus sample')") })
	}

	# The menu bar: each item has a sub menu
	oMenuBar = new NMenu {
		add(new NMenuItem("File") { setSubMenu(oFile) })
		add(new NMenuItem("View") { setSubMenu(oView) })
		add(new NMenuItem("Help") { setSubMenu(oHelp) })
	}
	return oMenuBar

func createPopupMenu
	oPopup = new NMenu {
		add(new NMenuItem("Cut") { setClickEvent("log('Popup: Cut')") })
		add(new NMenuItem("Copy") { setClickEvent("log('Popup: Copy')") })
		add(new NMenuItem("Paste") { setClickEvent("log('Popup: Paste')") })
	}
	return oPopup

func drawArea
	oCanvas = nappCanvas()
	oCanvas.clear(NAPP_COLOR_LIGHTGRAY)
	oCanvas.setTextAlign(ekCENTER, ekCENTER)
	oCanvas.text("Right click here", oCanvas.width() / 2, oCanvas.height() / 2)

func areaClick
	if nappEvent().button() = ekGUI_MOUSE_RIGHT
		oAppPopupMenu.popupAtMouse()
	ok

func toggleWrap
	lAppWrap = not lAppWrap
	oAppWrapItem.setChecked(lAppWrap)
	log("Word Wrap: " + lAppWrap)

func openFile
	cFile = nappOpenFile(oAppWindow, ["txt", "ring"])
	if cFile != NULL
		log("Open: " + cFile)
	ok

func log cText
	oAppText.writeLine(cText)
