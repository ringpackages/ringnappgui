# Drawing using NView and NCanvas: lines, shapes, gradients, text and polygons

load "nappguilib.ring"

oAppView = NULL
oAppTitleFont = NULL
oAppInfoFont = NULL

func main
	nappRun("createGUI()")

func createGUI
	oAppTitleFont = new NFont("", 24, ekFBOLD)
	oAppInfoFont = new NFont("", 14, ekFITALIC)
	oAppView = new NView {
		setSize(560, 380)
		setDrawEvent("draw()")
	}
	oLayout = new NLayout(1, 1) { add(oAppView, 1, 1) expandRow(1) expandColumn(1) }
	new NWindow("Drawing") { setResizable(True) setLayout(oLayout) show() }

func draw
	oCanvas = nappCanvas()
	nWidth = oCanvas.width()
	nHeight = oCanvas.height()

	# Background gradient
	oCanvas.setGradient([nappColor(235, 240, 255), nappColor(200, 215, 245)], [0, 1], 0, 0, 0, nHeight)
	oCanvas.rect(ekFILL, 0, 0, nWidth, nHeight)

	# Lines with different widths, caps and dashes
	oCanvas.setLineColor(NAPP_COLOR_DARKGRAY)
	for nLine = 1 to 5
		oCanvas.setLineWidth(nLine)
		oCanvas.line(20, 20 + nLine * 12, 160, 20 + nLine * 12)
	next
	oCanvas {
		setLineWidth(2)
		setLineColor(NAPP_COLOR_RED)
		setLineDash([8, 4])
		line(20, 100, 160, 100)
		setLineDash([2, 3])
		line(20, 112, 160, 112)
		setLineDash([])
	}

	# Shapes: stroke, fill, and fill with stroke
	oCanvas {
		setLineWidth(3)
		setLineColor(NAPP_COLOR_BLUE)
		setFillColor(nappColorAlpha(40, 90, 200, 120))
		rect(ekSTROKE, 190, 30, 90, 70)
		rect(ekFILL, 300, 30, 90, 70)
		roundRect(ekSKFILL, 410, 30, 120, 70, 15)
		setFillColor(NAPP_COLOR_ORANGE)
		circle(ekFILLSK, 235, 170, 40)
		ellipse(ekFILL, 345, 170, 55, 30)
		setFillColor(NAPP_COLOR_GREEN)
		polygon(ekSKFILL, starPoints(470, 170, 50, 22, 5))
	}

	# Arc and Bezier curve
	oCanvas {
		setLineColor(NAPP_COLOR_PURPLE)
		setLineWidth(4)
		arc(90, 200, 50, 0, 3.14159)
		bezier(20, 330, 120, 230, 200, 400, 300, 300)
	}

	# Text with fonts, colors and alignment
	oCanvas {
		setFont(oAppTitleFont)
		setTextColor(NAPP_COLOR_BLUE)
		text("NAppGUI Drawing", 320, 250)
		setFont(oAppInfoFont)
		setTextColor(NAPP_COLOR_DARKGRAY)
		text("Size: " + floor(nWidth) + " x " + floor(nHeight), 320, 290)
		setTextAlign(ekRIGHT, ekBOTTOM)
		text("Bottom right", nWidth - 10, nHeight - 10)
		setTextAlign(ekLEFT, ekTOP)
	}

func starPoints nX, nY, nOuter, nInner, nPoints
	aPoints = []
	for nPoint = 0 to nPoints * 2 - 1
		nRadius = nOuter
		if nPoint % 2 = 1 nRadius = nInner ok
		nAngle = nPoint * 3.14159 / nPoints - 3.14159 / 2
		aPoints + [nX + nRadius * cos(nAngle), nY + nRadius * sin(nAngle)]
	next
	return aPoints
