# Text boxes: placeholder, password, read only, filters and change events

load "nappguilib.ring"

oAppName = NULL
oAppPassword = NULL
oAppAge = NULL
oAppCode = NULL
oAppResult = NULL

func main
	nappRun("createGUI()")

func createGUI
	oAppName = new NEdit("") {
		setPlaceholder("Your name")
		setChangeEvent("showValues()")
	}
	oAppPassword = new NEdit("") { setPassword(True) }
	# The filter event runs at each key: keep the digits only
	oAppAge = new NEdit("") {
		setPlaceholder("Digits only")
		setAlign(ekRIGHT)
		setFilterEvent("digitsOnly()")
	}
	# Change the text to upper case while typing
	oAppCode = new NEdit("") {
		setPlaceholder("Upper case code")
		setFilterEvent("upperCase()")
	}
	oReadOnly = new NEdit("This text can't be changed") {
		setEditable(False)
		setBackColor(NAPP_COLOR_LIGHTGRAY)
	}
	oButton = new NButton("Show Values") { setClickEvent("showValues()") }
	oAppResult = new NTextView { setSize(300, 90) setEditable(False) }

	oLayout = new NLayout(2, 7) {
		add(new NLabel("Name:"), 1, 1)       add(oAppName, 2, 1)
		add(new NLabel("Password:"), 1, 2)   add(oAppPassword, 2, 2)
		add(new NLabel("Age:"), 1, 3)        add(oAppAge, 2, 3)
		add(new NLabel("Code:"), 1, 4)       add(oAppCode, 2, 4)
		add(new NLabel("Read only:"), 1, 5)  add(oReadOnly, 2, 5)
		add(oButton, 2, 6)
		add(oAppResult, 2, 7)
		setHAlignCell(2, 6, ekRIGHT)
		setColumnWidth(2, 300)
		setColumnMargin(1, 10)
		setRowsMargin(6)
		setMargin(15)
	}

	new NWindow("Text Boxes") { setLayout(oLayout) show() }

func digitsOnly
	oEvent = nappEvent()
	cText = oEvent.text()
	cDigits = ""
	for cChar in cText
		if isDigit(cChar) cDigits += cChar ok
	next
	if cDigits != cText
		oEvent.setFilterText(cDigits, len(cDigits))
	ok

func upperCase
	oEvent = nappEvent()
	cText = oEvent.text()
	if upper(cText) != cText
		oEvent.setFilterText(upper(cText), oEvent.caretPos())
	ok

func showValues
	oAppResult.setText("Name: " + oAppName.text() + nl +
			   "Password length: " + len(oAppPassword.text()) + nl +
			   "Age: " + oAppAge.text() + nl +
			   "Code: " + oAppCode.text())
