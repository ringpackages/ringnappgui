# Push buttons, check boxes and radio buttons

load "nappguilib.ring"

oAppStatus = NULL
oAppBold = NULL
oAppItalic = NULL
oAppSmall = NULL
oAppMedium = NULL
oAppLarge = NULL
oAppEnable = NULL
oAppOrder = NULL

func main
	nappRun("createGUI()")

func createGUI
	oAppBold = new NCheckBox("Bold") { setClickEvent("updateStatus()") }
	oAppItalic = new NCheckBox("Italic") { setChecked(True) setClickEvent("updateStatus()") }

	# The radio buttons of one layout make one group
	oAppSmall = new NRadioButton("Small") { setClickEvent("updateStatus()") }
	oAppMedium = new NRadioButton("Medium") { setChecked(True) setClickEvent("updateStatus()") }
	oAppLarge = new NRadioButton("Large") { setClickEvent("updateStatus()") }
	oSizeLayout = new NLayout(3, 1) {
		add(oAppSmall, 1, 1)  add(oAppMedium, 2, 1)  add(oAppLarge, 3, 1)
		setColumnsMargin(10)
	}

	oAppOrder = new NButton("Order") {
		setTooltip("Send the order")
		setClickEvent("order()")
	}
	oAppEnable = new NCheckBox("Enable the Order button") {
		setChecked(True)
		setClickEvent("enableOrder()")
	}
	oAppStatus = new NLabel("") { setSizeText(copy("W", 40)) }

	oLayout = new NLayout(1, 6) {
		add(oAppBold, 1, 1)
		add(oAppItalic, 1, 2)
		add(oSizeLayout, 1, 3)
		add(oAppEnable, 1, 4)
		add(oAppOrder, 1, 5)
		add(oAppStatus, 1, 6)
		setHAlignCell(1, 5, ekLEFT)
		setRowsMargin(8)
		setMargin(15)
	}

	oWindow = new NWindow("Buttons") { setLayout(oLayout) show() }
	oWindow.setDefaultButton(oAppOrder)
	updateStatus()

func updateStatus
	cStyle = ""
	if oAppBold.isChecked() cStyle += "Bold " ok
	if oAppItalic.isChecked() cStyle += "Italic " ok
	cSize = "Small"
	if oAppMedium.isChecked() cSize = "Medium" ok
	if oAppLarge.isChecked() cSize = "Large" ok
	oAppStatus.setText("Style: " + cStyle + "- Size: " + cSize)

func enableOrder
	oAppOrder.setEnabled(oAppEnable.isChecked())

func order
	oAppStatus.setText("Order sent at " + time())
