# Panels with pages: one panel holds many layouts and shows one of them (a wizard)

load "nappguilib.ring"

oAppPanel = NULL
oAppBack = NULL
oAppNext = NULL
oAppStep = NULL
oAppName = NULL
oAppPlan = NULL
oAppSummary = NULL
nAppPage = 1
nAppPages = 3

func main
	nappRun("createGUI()")

func createGUI
	# Page 1
	oAppName = new NEdit("") { setPlaceholder("Project name") }
	oPage1 = new NLayout(1, 3) {
		add(new NLabel("Step 1: Name") { setFont(new NFont("", 16, ekFBOLD)) }, 1, 1)
		add(new NLabel("Write the name of the project:"), 1, 2)
		add(oAppName, 1, 3)
		setRowsMargin(8)
	}

	# Page 2
	oAppPlan = new NPopUp { addItems(["Small", "Medium", "Large"]) }
	oPage2 = new NLayout(1, 3) {
		add(new NLabel("Step 2: Size") { setFont(new NFont("", 16, ekFBOLD)) }, 1, 1)
		add(new NLabel("Select the size of the project:"), 1, 2)
		add(oAppPlan, 1, 3)
		setRowsMargin(8)
	}

	# Page 3
	oAppSummary = new NLabel("Name:" + nl + "Size:") { setSizeText(copy("W", 25) + nl + "W") }
	oPage3 = new NLayout(1, 2) {
		add(new NLabel("Step 3: Summary") { setFont(new NFont("", 16, ekFBOLD)) }, 1, 1)
		add(oAppSummary, 1, 2)
		setRowsMargin(8)
	}

	# Use the size of the panel (not the size of the layout cell) for panels with many layouts
	oAppPanel = new NPanel {
		addLayout(oPage1)
		addLayout(oPage2)
		addLayout(oPage3)
		setSize(360, 120)
	}

	oAppStep = new NLabel("") { setSizeText("Page 0 of 0") }
	oAppBack = new NButton("< Back") { setClickEvent("goPage(nAppPage - 1)") }
	oAppNext = new NButton("Next >") { setClickEvent("goPage(nAppPage + 1)") }
	oButtons = new NLayout(4, 1) {
		add(oAppStep, 1, 1)
		add(oAppBack, 3, 1)
		add(oAppNext, 4, 1)
		expandColumn(2)
		setColumnMargin(3, 5)
	}

	oLayout = new NLayout(1, 2) {
		add(oAppPanel, 1, 1)
		add(oButtons, 1, 2)
		setRowMargin(1, 10)
		setMargin(15)
	}
	new NWindow("Project Wizard") { setLayout(oLayout) show() }
	goPage(1)

func goPage nPage
	if nPage < 1 return ok
	if nPage > nAppPages
		nappMessage(NULL, "Wizard", "Finished: " + oAppName.text())
		nappQuit()
		return
	ok
	nAppPage = nPage
	if nAppPage = 3
		cName = oAppName.text()
		if cName = "" cName = "(no name)" ok
		oAppSummary.setText("Name: " + cName + nl + "Size: " + oAppPlan.selectedText())
	ok
	oAppPanel.showLayout(nAppPage)
	oAppStep.setText("Page " + nAppPage + " of " + nAppPages)
	oAppBack.setEnabled(nAppPage > 1)
	if nAppPage = nAppPages
		oAppNext.setText("Finish")
	else
		oAppNext.setText("Next >")
	ok
