# Images: draw an image using NCanvas, save it as PNG, load it, scale it and show it

load "nappguilib.ring"

oAppImageView = NULL
oAppInfo = NULL
oAppImage = NULL
oAppScale = NULL
cAppFileName = "nappgui_sample_image.png"

func main
	nappRun("createGUI()")

func createGUI
	# Draw an image in memory (an offscreen canvas)
	oCanvas = new NCanvas
	oCanvas.createBitmap(240, 160)
	oCanvas.clear(NAPP_COLOR_WHITE)
	oCanvas.setGradient([NAPP_COLOR_YELLOW, NAPP_COLOR_ORANGE], [0, 1], 0, 0, 240, 160)
	oCanvas.rect(ekFILL, 0, 0, 240, 160)
	for nCircle = 1 to 6
		oCanvas.fillCircle(nCircle * 35, 80 + 40 * sin(nCircle), 15, nappColorHSB(nCircle / 6, 0.8, 0.9))
	next
	oCanvas.setFont(new NFont("", 20, ekFBOLD))
	oCanvas.setTextColor(NAPP_COLOR_BLUE)
	oCanvas.text("Ring + NAppGUI", 40, 10)
	oImage = oCanvas.toImage()

	# Save it, then load it from the file
	oImage.setCodec(ekPNG)
	lSaved = oImage.save(cAppFileName)
	oAppImage = new NImage(cAppFileName)

	oAppImageView = new NImageView {
		setSize(260, 180)
		setScale(ekGUI_SCALE_ASPECT)
		setImage(oAppImage)
	}
	oAppScale = new NPopUp {
		addItems(["Original size", "Half size", "Double size"])
		setSelectEvent("scaleImage()")
	}
	oOpen = new NButton("Open Image...") { setClickEvent("openImage()") }
	oAppInfo = new NLabel("") { setSizeText(copy("W", 30)) }

	oLayout = new NLayout(1, 4) {
		add(oAppImageView, 1, 1)
		add(oAppScale, 1, 2)
		add(oOpen, 1, 3)
		add(oAppInfo, 1, 4)
		setRowsMargin(6)
		setMargin(10)
		expandRow(1)
	}
	new NWindow("Images") { setResizable(True) setLayout(oLayout) show() }
	showInfo(oAppImage)
	if not lSaved oAppInfo.setText("Can't save the image") ok

func scaleImage
	nWidth = oAppImage.width()
	nHeight = oAppImage.height()
	switch oAppScale.selected()
	on 1
		oAppImageView.setImage(oAppImage)
		showInfo(oAppImage)
	on 2
		oScaled = oAppImage.scaled(nWidth / 2, nHeight / 2)
		oAppImageView.setImage(oScaled)
		showInfo(oScaled)
	on 3
		oScaled = oAppImage.scaled(nWidth * 2, nHeight * 2)
		oAppImageView.setImage(oScaled)
		showInfo(oScaled)
	off

func openImage
	cFile = nappOpenFile(NULL, ["png", "jpg", "bmp", "gif"])
	if cFile = NULL return ok
	oNewImage = new NImage
	if oNewImage.loadFile(cFile)
		oAppImage = oNewImage
		oAppScale.setSelected(1)
		oAppImageView.setImage(oAppImage)
		showInfo(oAppImage)
	else
		nappMessage(NULL, "Images", "Can't load the image")
	ok

func showInfo oImage
	oAppInfo.setText("Image size: " + oImage.width() + " x " + oImage.height())
