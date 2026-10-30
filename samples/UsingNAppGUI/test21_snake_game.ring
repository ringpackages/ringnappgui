# The Snake game: keyboard events, a timer and drawing
# Use the arrow keys to move, P to pause and Space to start again

load "nappguilib.ring"

C_CELL = 20
C_COLS = 24
C_ROWS = 18

oAppView = NULL
oAppScore = NULL
aAppSnake = []
aAppFood = []
nAppDirX = 1
nAppDirY = 0
nAppNextX = 1
nAppNextY = 0
nAppScore = 0
lAppGameOver = False
lAppPaused = False

func main
	nappRunTimer("createGUI()", 0.01)

func createGUI
	oAppScore = new NLabel("") { setSizeText(copy("W", 25)) setFont(new NFont("", 16, ekFBOLD)) }
	oAppView = new NView {
		setSize(C_COLS * C_CELL, C_ROWS * C_CELL)
		setDrawEvent("drawGame()")
		setKeyDownEvent("keyDown()")
	}
	oLayout = new NLayout(1, 3) {
		add(oAppScore, 1, 1)
		add(oAppView, 1, 2)
		add(new NLabel("Arrows: move - P: pause - Space: new game"), 1, 3)
		setRowsMargin(6)
		setMargin(10)
	}
	oWindow = new NWindow("Snake") { setLayout(oLayout) show() }
	oWindow.setFocus(oAppView)
	newGame()
	nappAddTimer(0.12, "step()")

func newGame
	aAppSnake = [[6, 9], [5, 9], [4, 9]]
	nAppDirX = 1  nAppDirY = 0
	nAppNextX = 1  nAppNextY = 0
	nAppScore = 0
	lAppGameOver = False
	lAppPaused = False
	placeFood()
	showScore()

func placeFood
	while True
		aAppFood = [random(C_COLS - 1), random(C_ROWS - 1)]
		if not isSnake(aAppFood[1], aAppFood[2]) exit ok
	end

func isSnake nX, nY
	for aPart in aAppSnake
		if aPart[1] = nX and aPart[2] = nY return True ok
	next
	return False

func keyDown
	nKey = nappEvent().key()
	switch nKey
	on ekKEY_UP    if nAppDirY = 0 nAppNextX = 0  nAppNextY = -1 ok
	on ekKEY_DOWN  if nAppDirY = 0 nAppNextX = 0  nAppNextY = 1 ok
	on ekKEY_LEFT  if nAppDirX = 0 nAppNextX = -1 nAppNextY = 0 ok
	on ekKEY_RIGHT if nAppDirX = 0 nAppNextX = 1  nAppNextY = 0 ok
	on ekKEY_P     lAppPaused = not lAppPaused showScore()
	on ekKEY_SPACE newGame()
	off

func step
	if lAppGameOver or lAppPaused return ok
	nAppDirX = nAppNextX
	nAppDirY = nAppNextY
	nX = aAppSnake[1][1] + nAppDirX
	nY = aAppSnake[1][2] + nAppDirY
	if nX < 0 or nY < 0 or nX >= C_COLS or nY >= C_ROWS or isSnake(nX, nY)
		lAppGameOver = True
		showScore()
		oAppView.update()
		return
	ok
	insert(aAppSnake, 0, [nX, nY])
	if nX = aAppFood[1] and nY = aAppFood[2]
		nAppScore += 10
		placeFood()
		showScore()
	else
		del(aAppSnake, len(aAppSnake))
	ok
	oAppView.update()

func showScore
	cText = "Score: " + nAppScore
	if lAppGameOver cText += " - Game Over" ok
	if lAppPaused cText += " - Paused" ok
	oAppScore.setText(cText)

func drawGame
	oCanvas = nappCanvas()
	oCanvas.clear(nappColor(30, 40, 30))
	# Food
	oCanvas.fillCircle(aAppFood[1] * C_CELL + C_CELL / 2, aAppFood[2] * C_CELL + C_CELL / 2, C_CELL / 2 - 2, NAPP_COLOR_RED)
	# Snake
	nCount = len(aAppSnake)
	for nPart = 1 to nCount
		nColor = nappColor(80, 200, 90)
		if nPart = 1 nColor = nappColor(160, 240, 120) ok
		oCanvas.setFillColor(nColor)
		oCanvas.roundRect(ekFILL, aAppSnake[nPart][1] * C_CELL + 1, aAppSnake[nPart][2] * C_CELL + 1,
				  C_CELL - 2, C_CELL - 2, 4)
	next
	if lAppGameOver
		oCanvas.setTextColor(NAPP_COLOR_WHITE)
		oCanvas.setTextAlign(ekCENTER, ekCENTER)
		oCanvas.text("Game Over - press Space", oCanvas.width() / 2, oCanvas.height() / 2)
	ok
