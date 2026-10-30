# Timers and animation: a clock updated each second, and balls moved at each frame

load "nappguilib.ring"

oAppClock = NULL
oAppView = NULL
oAppPause = NULL
aAppBalls = []      # [nX, nY, nSpeedX, nSpeedY, nRadius, nColor]
nAppLastTime = 0
lAppPaused = False

func main
	# The main loop runs each 0.015 seconds (about 60 frames per second)
	nappRunTimer("createGUI()", 0.015)

func createGUI
	oAppClock = new NLabel("") {
		setFont(new NFont("", 28, ekFBOLD))
		setSizeText("00:00:00")
		setColor(NAPP_COLOR_BLUE)
	}
	oAppView = new NView { setSize(500, 300) setDrawEvent("drawBalls()") setClickEvent("addBall()") }
	oAppPause = new NButton("Pause") { setClickEvent("togglePause()") }
	oAdd = new NButton("Add Ball") { setClickEvent("addBall()") }
	oButtons = new NLayout(3, 1) {
		add(new NLabel("Click the view to add a ball"), 1, 1)
		add(oAdd, 2, 1)
		add(oAppPause, 3, 1)
		expandColumn(1)
		setColumnMargin(2, 5)
	}
	oLayout = new NLayout(1, 3) {
		add(oAppClock, 1, 1)
		add(oAppView, 1, 2)
		add(oButtons, 1, 3)
		setHAlignCell(1, 1, ekCENTER)
		setRowsMargin(8)
		setMargin(10)
	}
	new NWindow("Timers and Animation") { setLayout(oLayout) show() }

	for nBall = 1 to 5 addBall() next
	updateClock()
	nappAddTimer(1, "updateClock()")
	nappSetUpdateEvent("moveBalls()")

func updateClock
	oAppClock.setText(time())

func addBall
	aColors = [NAPP_COLOR_RED, NAPP_COLOR_GREEN, NAPP_COLOR_BLUE, NAPP_COLOR_ORANGE, NAPP_COLOR_PURPLE]
	aAppBalls + [random(400) + 50, random(200) + 50, random(200) + 100, random(200) + 100,
		     random(15) + 10, aColors[random(4) + 1]]

func togglePause
	lAppPaused = not lAppPaused
	if lAppPaused
		oAppPause.setText("Resume")
	else
		oAppPause.setText("Pause")
	ok

func moveBalls
	nNow = nappTime()
	nDelta = nNow - nAppLastTime
	nAppLastTime = nNow
	if lAppPaused or nDelta > 0.2 return ok
	aSize = oAppView.size()
	nCount = len(aAppBalls)
	for nBall = 1 to nCount
		aBall = aAppBalls[nBall]
		aBall[1] += aBall[3] * nDelta
		aBall[2] += aBall[4] * nDelta
		if aBall[1] < aBall[5] or aBall[1] > aSize[1] - aBall[5]
			aBall[3] = -aBall[3]
			aBall[1] = max([aBall[5], min([aBall[1], aSize[1] - aBall[5]])])
		ok
		if aBall[2] < aBall[5] or aBall[2] > aSize[2] - aBall[5]
			aBall[4] = -aBall[4]
			aBall[2] = max([aBall[5], min([aBall[2], aSize[2] - aBall[5]])])
		ok
		aAppBalls[nBall] = aBall
	next
	oAppView.update()

func drawBalls
	oCanvas = nappCanvas()
	oCanvas.clear(nappColor(20, 24, 40))
	for aBall in aAppBalls
		oCanvas.fillCircle(aBall[1], aBall[2], aBall[5], aBall[6])
	next
	oCanvas.setTextColor(NAPP_COLOR_WHITE)
	oCanvas.text("Balls: " + len(aAppBalls), 10, 10)
