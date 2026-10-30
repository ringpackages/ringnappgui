# Dialogs: message, confirm, input, open file, save file and color selection

load "nappguilib.ring"

oAppWindow = NULL
oAppResult = NULL
oAppColorBox = NULL
nAppColor = 0

func main
	nappRun("createGUI()")

func createGUI
	nAppColor = NAPP_COLOR_BLUE
	aButtons = [
		["Message", "showMessage()"],
		["Confirm", "showConfirm()"],
		["Input", "showInput()"],
		["Open File", "showOpenFile()"],
		["Save File", "showSaveFile()"],
		["Select Color", "showColor()"]
	]
	nButtons = len(aButtons)
	oButtons = new NLayout(1, nButtons)
	for nButton = 1 to nButtons
		oButton = new NButton(aButtons[nButton][1])
		oButton.setClickEvent(aButtons[nButton][2])
		oButtons.add(oButton, 1, nButton)
	next
	oButtons.setRowsMargin(5)

	oAppResult = new NTextView { setSize(320, 200) setEditable(False) }
	oAppColorBox = new NView { setSize(320, 30) setDrawEvent("drawColor()") }
	oRight = new NLayout(1, 2) {
		add(oAppResult, 1, 1)
		add(oAppColorBox, 1, 2)
		setRowMargin(1, 5)
	}

	oLayout = new NLayout(2, 1) {
		add(oButtons, 1, 1)
		add(oRight, 2, 1)
		setVAlignCell(1, 1, ekTOP)
		setColumnMargin(1, 10)
		setMargin(10)
	}
	oAppWindow = new NWindow("Dialogs") { setLayout(oLayout) show() }

func showMessage
	nappMessage(oAppWindow, "Message", "This is a message." + nl + "Press OK to continue.")
	log("Message closed")

func showConfirm
	if nappConfirm(oAppWindow, "Confirm", "Do you like Ring?")
		log("Confirm: Yes")
	else
		log("Confirm: No")
	ok

func showInput
	cName = nappInput(oAppWindow, "Input", "Write your name:", "Sample User")
	if cName = NULL
		log("Input: canceled")
	else
		log("Input: " + cName)
	ok

func showOpenFile
	cFile = nappOpenFile(oAppWindow, ["ring", "txt"])
	log("Open: " + cFile)

func showSaveFile
	cFile = nappSaveFile(oAppWindow, ["txt"])
	log("Save: " + cFile)

func showColor
	nappChooseColor(oAppWindow, "Select a color", nAppColor, "colorChanged()")

func colorChanged
	nAppColor = nappEvent().color()
	oAppColorBox.update()
	log("Color: " + nappColorToHex(nAppColor))

func drawColor
	oCanvas = nappCanvas()
	oCanvas.clear(nAppColor)

func log cText
	oAppResult.writeLine(cText)
