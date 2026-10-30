# Scroll views: a large drawing (2000 x 2000) inside a view with scroll bars,
# and a scroll panel with many controls

load "nappguilib.ring"

oAppView = NULL
oAppPos = NULL

func main
	nappRun("createGUI()")

func createGUI
	oAppView = new NScrollView {
		setSize(360, 300)
		setContentSize(2000, 2000, 20, 20)
		setDrawEvent("drawMap()")
		setScrollEvent("showPosition()")
	}
	oAppPos = new NLabel("") { setSizeText(copy("W", 20)) }

	# A scroll panel with 30 rows of controls
	oRows = new NLayout(2, 30)
	for nRow = 1 to 30
		oRows.add(new NLabel("Setting " + nRow), 1, nRow)
		oRows.add(new NCheckBox("Enabled"), 2, nRow)
	next
	oRows.setColumnsMargin(10)
	oRows.setRowsMargin(4)
	oRows.setMargin(5)
	oPanel = new NScrollPanel { setLayout(oRows) setSize(200, 300) }

	oLayout = new NLayout(2, 2) {
		add(oAppView, 1, 1)
		add(oPanel, 2, 1)
		add(oAppPos, 1, 2)
		setColumnMargin(1, 10)
		setRowMargin(1, 5)
		setMargin(10)
		expandColumn(1)
		expandRow(1)
	}
	new NWindow("Scroll Views") { setResizable(True) setLayout(oLayout) show() }
	showPosition()

func drawMap
	oCanvas = nappCanvas()
	aViewport = oAppView.viewport()
	oCanvas.clear(NAPP_COLOR_WHITE)
	# Draw only the visible cells
	nFirstCol = floor(aViewport[1] / 100)
	nFirstRow = floor(aViewport[2] / 100)
	nLastCol = min([19, floor((aViewport[1] + aViewport[3]) / 100)])
	nLastRow = min([19, floor((aViewport[2] + aViewport[4]) / 100)])
	oCanvas.setTextAlign(ekCENTER, ekCENTER)
	for nRow = nFirstRow to nLastRow
		for nCol = nFirstCol to nLastCol
			nColor = nappColorHSB((nCol + nRow) / 40, 0.35, 0.95)
			oCanvas.fillRect(nCol * 100 + 2, nRow * 100 + 2, 96, 96, nColor)
			oCanvas.setTextColor(NAPP_COLOR_DARKGRAY)
			oCanvas.text("" + (nCol + 1) + "," + (nRow + 1), nCol * 100 + 50, nRow * 100 + 50)
		next
	next

func showPosition
	aViewport = oAppView.viewport()
	oAppPos.setText("Position: " + floor(aViewport[1]) + ", " + floor(aViewport[2]))
