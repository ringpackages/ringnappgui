# Charts: a bar chart and a line chart drawn using NCanvas (they are drawn again when resized)

load "nappguilib.ring"

oAppBars = NULL
oAppLines = NULL
oAppType = NULL
aAppMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
aAppSeries = []

func main
	nappRun("createGUI()")

func createGUI
	randomData()
	oAppBars = new NView { setSize(520, 220) setDrawEvent("drawBars()") }
	oAppLines = new NView { setSize(520, 220) setDrawEvent("drawLines()") }
	oNew = new NButton("New Data") { setClickEvent("randomData() oAppBars.update() oAppLines.update()") }
	oLayout = new NLayout(1, 3) {
		add(oAppBars, 1, 1)
		add(oAppLines, 1, 2)
		add(oNew, 1, 3)
		setHAlignCell(1, 3, ekRIGHT)
		setRowsMargin(8)
		setMargin(10)
		expandRow(1)
		expandRow(2)
	}
	new NWindow("Charts") { setResizable(True) setLayout(oLayout) show() }

func randomData
	aAppSeries = [[], []]
	for nMonth = 1 to 12
		aAppSeries[1] + (random(80) + 20)
		aAppSeries[2] + (random(60) + 10)
	next

func chartArea oCanvas
	# [nLeft, nTop, nWidth, nHeight] inside the margins
	return [40, 30, oCanvas.width() - 60, oCanvas.height() - 60]

func drawAxes oCanvas, cTitle, aArea, nMax
	oCanvas.clear(NAPP_COLOR_WHITE)
	oCanvas.setTextColor(NAPP_COLOR_DARKGRAY)
	oCanvas.setTextAlign(ekLEFT, ekTOP)
	oCanvas.text(cTitle, 10, 6)
	oCanvas.setLineWidth(1)
	oCanvas.setLineDash([3, 3])
	oCanvas.setLineColor(NAPP_COLOR_LIGHTGRAY)
	oCanvas.setTextAlign(ekRIGHT, ekCENTER)
	for nStep = 0 to 4
		nY = aArea[2] + aArea[4] - aArea[4] * nStep / 4
		oCanvas.line(aArea[1], nY, aArea[1] + aArea[3], nY)
		oCanvas.text("" + floor(nMax * nStep / 4), aArea[1] - 6, nY)
	next
	oCanvas.setLineDash([])
	oCanvas.setLineColor(NAPP_COLOR_GRAY)
	oCanvas.line(aArea[1], aArea[2] + aArea[4], aArea[1] + aArea[3], aArea[2] + aArea[4])
	oCanvas.setTextAlign(ekCENTER, ekTOP)
	nSlot = aArea[3] / 12
	for nMonth = 1 to 12
		oCanvas.text(aAppMonths[nMonth], aArea[1] + nSlot * (nMonth - 0.5), aArea[2] + aArea[4] + 4)
	next

func drawBars
	oCanvas = nappCanvas()
	aArea = chartArea(oCanvas)
	drawAxes(oCanvas, "Sales (bar chart)", aArea, 100)
	nSlot = aArea[3] / 12
	nBar = nSlot * 0.35
	aColors = [NAPP_COLOR_BLUE, NAPP_COLOR_ORANGE]
	for nSeries = 1 to 2
		for nMonth = 1 to 12
			nHeight = aArea[4] * aAppSeries[nSeries][nMonth] / 100
			nX = aArea[1] + nSlot * (nMonth - 1) + nSlot * 0.12 + (nSeries - 1) * nBar
			oCanvas.fillRect(nX, aArea[2] + aArea[4] - nHeight, nBar, nHeight, aColors[nSeries])
		next
	next

func drawLines
	oCanvas = nappCanvas()
	aArea = chartArea(oCanvas)
	drawAxes(oCanvas, "Visitors (line chart)", aArea, 100)
	nSlot = aArea[3] / 12
	aColors = [NAPP_COLOR_GREEN, NAPP_COLOR_PURPLE]
	for nSeries = 1 to 2
		aPoints = []
		for nMonth = 1 to 12
			aPoints + [aArea[1] + nSlot * (nMonth - 0.5), aArea[2] + aArea[4] - aArea[4] * aAppSeries[nSeries][nMonth] / 100]
		next
		oCanvas.setLineColor(aColors[nSeries])
		oCanvas.setLineWidth(3)
		oCanvas.polyline(False, aPoints)
		for aPoint in aPoints
			oCanvas.fillCircle(aPoint[1], aPoint[2], 4, aColors[nSeries])
		next
	next
