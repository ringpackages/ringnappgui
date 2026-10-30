# Labels: fonts, colors, alignment, multi-line text and clickable labels (links)

load "nappguilib.ring"

oAppCounter = NULL
nAppCount = 0

func main
	nappRun("createGUI()")

func createGUI
	oTitle = new NLabel("NAppGUI Labels") {
		setFont(new NFont("", 22, ekFBOLD))
		setColor(NAPP_COLOR_BLUE)
	}
	oItalic = new NLabel("Italic and underlined text") {
		setFont(new NFont("", 14, ekFITALIC | ekFUNDERLINE))
	}
	oMono = new NLabel("Monospace font: 0123456789") {
		setFont(new NFont("monospace", 13, ekFNORMAL))
	}
	oColors = new NLabel("White text on a dark background") {
		setColor(NAPP_COLOR_WHITE)
		setBackColor(NAPP_COLOR_DARKGRAY)
	}
	oMulti = new NLabel("A label with new lines" + nl +
			    "is a multi-line label." + nl +
			    "Each line is shown below the previous line.")
	oLink = new NLabel("Visit the Ring website") {
		setColor(NAPP_COLOR_BLUE)
		setHoverColor(NAPP_COLOR_RED)
		setHoverStyle(ekFUNDERLINE)
		setClickEvent("nappOpenURL('https://ring-lang.github.io')")
	}
	oAppCounter = new NLabel("Click me: 0") {
		setSizeText("Click me: 00000")
		setHoverBackColor(NAPP_COLOR_LIGHTGRAY)
		setClickEvent("countClick()")
	}
	oRight = new NLabel("Right aligned") { setAlign(ekRIGHT) }

	oLayout = new NLayout(1, 8) {
		add(oTitle, 1, 1)
		add(oItalic, 1, 2)
		add(oMono, 1, 3)
		add(oColors, 1, 4)
		add(oMulti, 1, 5)
		add(oLink, 1, 6)
		add(oAppCounter, 1, 7)
		add(oRight, 1, 8)
		setHAlignCell(1, 8, ekJUSTIFY)
		setColumnWidth(1, 360)
		setRowsMargin(8)
		setMargin(15)
	}

	new NWindow("Labels and Fonts") { setLayout(oLayout) show() }

func countClick
	nAppCount++
	oAppCounter.setText("Click me: " + nAppCount)
