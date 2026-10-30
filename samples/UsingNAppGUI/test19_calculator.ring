# A calculator: a grid of buttons, a display and keyboard shortcuts

load "nappguilib.ring"

oAppDisplay = NULL
cAppCurrent = "0"
nAppStored = 0
cAppOperation = ""
lAppNewNumber = True

func main
	nappRun("createGUI()")

func createGUI
	oAppDisplay = new NLabel("0") {
		setFont(new NFont("", 26, ekFBOLD))
		setAlign(ekRIGHT)
		setBackColor(NAPP_COLOR_WHITE)
	}

	aKeys = [
		["C", "(", ")", "/"],
		["7", "8", "9", "*"],
		["4", "5", "6", "-"],
		["1", "2", "3", "+"],
		["+/-", "0", ".", "="]
	]
	oKeys = new NLayout(4, 5)
	oFont = new NFont("", 16, ekFNORMAL)
	for nRow = 1 to 5
		for nCol = 1 to 4
			cKey = aKeys[nRow][nCol]
			oButton = new NButton(cKey)
			oButton.setFont(oFont)
			oButton.setVPadding(10)
			oButton.setClickEvent("pressKey('" + cKey + "')")
			oKeys.add(oButton, nCol, nRow)
		next
	next
	oKeys.setColumnsMargin(4)
	oKeys.setRowsMargin(4)
	for nCol = 1 to 4 oKeys.setColumnWidth(nCol, 60) next

	oLayout = new NLayout(1, 2) {
		add(oAppDisplay, 1, 1)
		add(oKeys, 1, 2)
		setHAlignCell(1, 1, ekJUSTIFY)
		setRowMargin(1, 10)
		setMargin(10)
	}
	oWindow = new NWindow("Calculator") { setLayout(oLayout) }

	# Keyboard shortcuts
	aHotKeys = [[ekKEY_0, "0"], [ekKEY_1, "1"], [ekKEY_2, "2"], [ekKEY_3, "3"], [ekKEY_4, "4"],
		    [ekKEY_5, "5"], [ekKEY_6, "6"], [ekKEY_7, "7"], [ekKEY_8, "8"], [ekKEY_9, "9"],
		    [ekKEY_NUMADD, "+"], [ekKEY_NUMMINUS, "-"], [ekKEY_NUMMULT, "*"], [ekKEY_NUMDIV, "/"],
		    [ekKEY_RETURN, "="], [ekKEY_ESCAPE, "C"], [ekKEY_PERIOD, "."]]
	for aHotKey in aHotKeys
		oWindow.addHotKey(aHotKey[1], ekMKEY_NONE, "pressKey('" + aHotKey[2] + "')")
	next
	oWindow.show()

func pressKey cKey
	switch cKey
	on "C"
		cAppCurrent = "0"  nAppStored = 0  cAppOperation = ""  lAppNewNumber = True
	on "+/-"
		if cAppCurrent != "0"
			if left(cAppCurrent, 1) = "-"
				cAppCurrent = substr(cAppCurrent, 2)
			else
				cAppCurrent = "-" + cAppCurrent
			ok
		ok
	on "."
		if lAppNewNumber
			cAppCurrent = "0."
			lAppNewNumber = False
		but substr(cAppCurrent, ".") = 0
			cAppCurrent += "."
		ok
	on "("
	on ")"
		# Not used by this simple calculator
	on "="
		calculate()
		cAppOperation = ""
	other
		if isDigit(cKey)
			if lAppNewNumber or cAppCurrent = "0"
				cAppCurrent = cKey
				lAppNewNumber = False
			else
				cAppCurrent += cKey
			ok
		else
			# An operation: + - * /
			if cAppOperation != "" and not lAppNewNumber
				calculate()
			else
				nAppStored = 0 + cAppCurrent
			ok
			cAppOperation = cKey
			lAppNewNumber = True
		ok
	off
	oAppDisplay.setText(cAppCurrent)

func calculate
	nValue = 0 + cAppCurrent
	switch cAppOperation
	on "+" nAppStored += nValue
	on "-" nAppStored -= nValue
	on "*" nAppStored *= nValue
	on "/"
		if nValue = 0
			cAppCurrent = "Error"
			lAppNewNumber = True
			return
		ok
		nAppStored /= nValue
	other
		nAppStored = nValue
	off
	cAppCurrent = formatNumber(nAppStored)
	lAppNewNumber = True

func formatNumber nValue
	cValue = "" + nValue
	if substr(cValue, ".") > 0
		# Remove the zeros at the end
		while right(cValue, 1) = "0" cValue = left(cValue, len(cValue) - 1) end
		if right(cValue, 1) = "." cValue = left(cValue, len(cValue) - 1) ok
	ok
	return cValue
