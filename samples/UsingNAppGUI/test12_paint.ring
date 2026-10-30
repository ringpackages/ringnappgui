# A paint program: mouse events (down, drag, up, wheel) and keyboard events
# Drag the mouse to draw. Keys: 1-5 select a color, C clears, the wheel changes the pen size.

load "nappguilib.ring"

oAppView = NULL
oAppStatus = NULL
aAppStrokes = []       # Each stroke: [nColor, nWidth, aPoints]
aAppColors = []
nAppColor = 1
nAppPenWidth = 4

func main
	nappRun("createGUI()")

func createGUI
	aAppColors = [NAPP_COLOR_BLACK, NAPP_COLOR_RED, NAPP_COLOR_GREEN, NAPP_COLOR_BLUE, NAPP_COLOR_ORANGE]
	oAppView = new NView {
		setSize(600, 400)
		setDrawEvent("draw()")
		setMouseDownEvent("mouseDown()")
		setDragEvent("mouseDrag()")
		setWheelEvent("mouseWheel()")
		setKeyDownEvent("keyDown()")
	}
	oAppStatus = new NLabel("") { setSizeText(copy("W", 50)) }
	oClear = new NButton("Clear") { setClickEvent("clearAll()") }
	oSave = new NButton("Save PNG") { setClickEvent("savePNG()") }
	oBottom = new NLayout(3, 1) {
		add(oAppStatus, 1, 1)  add(oClear, 2, 1)  add(oSave, 3, 1)
		expandColumn(1)
		setColumnMargin(2, 5)
	}
	oLayout = new NLayout(1, 2) {
		add(oAppView, 1, 1)
		add(oBottom, 1, 2)
		setRowMargin(1, 5)
		setMargin(5)
		expandRow(1)
	}
	new NWindow("Paint") { setResizable(True) setLayout(oLayout) show() }
	showStatus()

func draw
	drawStrokes(nappCanvas())

func drawStrokes oCanvas
	oCanvas.clear(NAPP_COLOR_WHITE)
	oCanvas.setLineCap(ekLCROUND)
	oCanvas.setLineJoin(ekLJROUND)
	for aStroke in aAppStrokes
		oCanvas.setLineColor(aStroke[1])
		oCanvas.setLineWidth(aStroke[2])
		if len(aStroke[3]) = 1
			oCanvas.fillCircle(aStroke[3][1][1], aStroke[3][1][2], aStroke[2] / 2, aStroke[1])
		else
			oCanvas.polyline(False, aStroke[3])
		ok
	next

func mouseDown
	oEvent = nappEvent()
	if oEvent.button() = ekGUI_MOUSE_LEFT
		aAppStrokes + [aAppColors[nAppColor], nAppPenWidth, [[oEvent.x(), oEvent.y()]]]
		oAppView.update()
	ok

func mouseDrag
	oEvent = nappEvent()
	nCount = len(aAppStrokes)
	if nCount > 0
		aAppStrokes[nCount][3] + [oEvent.x(), oEvent.y()]
		oAppView.update()
	ok

func mouseWheel
	if nappEvent().wheel() > 0
		nAppPenWidth = min([nAppPenWidth + 1, 40])
	else
		nAppPenWidth = max([nAppPenWidth - 1, 1])
	ok
	showStatus()

func keyDown
	nKey = nappEvent().key()
	aKeys = [ekKEY_1, ekKEY_2, ekKEY_3, ekKEY_4, ekKEY_5]
	nFound = find(aKeys, nKey)
	if nFound > 0
		nAppColor = nFound
	but nKey = ekKEY_C
		clearAll()
	ok
	showStatus()

func clearAll
	aAppStrokes = []
	oAppView.update()

func savePNG
	cFile = nappSaveFile(NULL, ["png"])
	if cFile = NULL return ok
	if lower(right(cFile, 4)) != ".png" cFile += ".png" ok
	aSize = oAppView.size()
	oCanvas = new NCanvas
	oCanvas.createBitmap(aSize[1], aSize[2])
	drawStrokes(oCanvas)
	oImage = oCanvas.toImage()
	oImage.setCodec(ekPNG)
	if oImage.save(cFile)
		oAppStatus.setText("Saved: " + cFile)
	ok
	oImage.destroy()

func showStatus
	aNames = ["Black", "Red", "Green", "Blue", "Orange"]
	oAppStatus.setText("Color (keys 1-5): " + aNames[nAppColor] + " - Pen (wheel): " + nAppPenWidth +
			   " - C: clear")
