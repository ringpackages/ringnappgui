# A color picker: three sliders, a preview drawn in a view, HTML colors and the system color dialog

load "nappguilib.ring"

oAppWindow = NULL
aAppSliders = []
aAppValues = []
oAppPreview = NULL
oAppHex = NULL
oAppPalette = NULL
nAppColor = 0
aAppSaved = []

func main
	nappRun("createGUI()")

func createGUI
	aNames = ["Red", "Green", "Blue"]
	oSliders = new NLayout(3, 3)
	for nChannel = 1 to 3
		oSlider = new NSlider
		oSlider.setRange(0, 255)
		oSlider.setValue(100 + nChannel * 40)
		oSlider.setMoveEvent("colorChanged()")
		oValue = new NLabel("000")
		oSliders.add(new NLabel(aNames[nChannel]), 1, nChannel)
		oSliders.add(oSlider, 2, nChannel)
		oSliders.add(oValue, 3, nChannel)
		aAppSliders + oSlider
		aAppValues + oValue
	next
	oSliders.setColumnWidth(2, 220)
	oSliders.setColumnsMargin(8)
	oSliders.setRowsMargin(6)

	oAppPreview = new NView { setSize(330, 90) setDrawEvent("drawPreview()") }
	oAppHex = new NEdit("") { setChangeEvent("hexChanged()") setTooltip("Write a color like #3366CC") }
	oSystem = new NButton("System Dialog...") { setClickEvent("systemDialog()") }
	oSave = new NButton("Save Color") { setClickEvent("saveColor()") }
	oRow = new NLayout(3, 1) {
		add(oAppHex, 1, 1)  add(oSystem, 2, 1)  add(oSave, 3, 1)
		expandColumn(1)
		setColumnsMargin(5)
	}
	oAppPalette = new NView { setSize(330, 30) setDrawEvent("drawPalette()") }

	oLayout = new NLayout(1, 4) {
		add(oSliders, 1, 1)
		add(oAppPreview, 1, 2)
		add(oRow, 1, 3)
		add(oAppPalette, 1, 4)
		setRowsMargin(10)
		setMargin(12)
	}
	oAppWindow = new NWindow("Color Picker") { setLayout(oLayout) show() }
	colorChanged()

func colorChanged
	aRGB = []
	for nChannel = 1 to 3
		nValue = floor(aAppSliders[nChannel].value())
		aAppValues[nChannel].setText("" + nValue)
		aRGB + nValue
	next
	nAppColor = nappColor(aRGB[1], aRGB[2], aRGB[3])
	oAppHex.setText(nappColorToHex(nAppColor))
	oAppPreview.update()

func setColor nColor
	aParts = nappColorParts(nColor)
	for nChannel = 1 to 3
		aAppSliders[nChannel].setValue(aParts[nChannel])
	next
	colorChanged()

func hexChanged
	cHex = trim(oAppHex.text())
	if left(cHex, 1) != "#" cHex = "#" + cHex ok
	if len(cHex) = 7
		setColor(nappColorHex(cHex))
	ok

func systemDialog
	nappChooseColor(oAppWindow, "Color", nAppColor, "setColor(nappEvent().color())")

func saveColor
	aAppSaved + nAppColor
	if len(aAppSaved) > 11 del(aAppSaved, 1) ok
	oAppPalette.update()

func drawPreview
	oCanvas = nappCanvas()
	oCanvas.clear(NAPP_COLOR_WHITE)
	oCanvas.setFillColor(nAppColor)
	oCanvas.roundRect(ekFILL, 2, 2, oCanvas.width() - 4, oCanvas.height() - 4, 10)
	# Use black or white text, depending on the brightness
	aParts = nappColorParts(nAppColor)
	nBright = aParts[1] * 0.299 + aParts[2] * 0.587 + aParts[3] * 0.114
	if nBright > 140
		oCanvas.setTextColor(NAPP_COLOR_BLACK)
	else
		oCanvas.setTextColor(NAPP_COLOR_WHITE)
	ok
	oCanvas.setTextAlign(ekCENTER, ekCENTER)
	oCanvas.text(nappColorToHex(nAppColor), oCanvas.width() / 2, oCanvas.height() / 2)

func drawPalette
	oCanvas = nappCanvas()
	oCanvas.clear(NAPP_COLOR_LIGHTGRAY)
	nX = 2
	for nColor in aAppSaved
		oCanvas.fillRect(nX, 2, 26, oCanvas.height() - 4, nColor)
		nX += 30
	next
