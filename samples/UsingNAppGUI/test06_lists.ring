# Popup lists, combo boxes and list boxes (check boxes and multiple selection)

load "nappguilib.ring"

oAppCountry = NULL
oAppCity = NULL
oAppTasks = NULL
oAppColors = NULL
oAppInfo = NULL

aAppCities = [
	["City A1", "City A2", "City A3"],
	["City B1", "City B2"],
	["City C1", "City C2", "City C3", "City C4"]
]

func main
	nappRun("createGUI()")

func createGUI
	oAppCountry = new NPopUp {
		addItems(["Country A", "Country B", "Country C"])
		setSelectEvent("countryChanged()")
	}
	oAppCity = new NPopUp
	fillCities(1)

	oFruit = new NCombo {
		addItems(["Apple", "Banana", "Orange"])
		setPlaceholder("Type or select a fruit")
		setChangeEvent("showInfo('Fruit: ' + nappEvent().text())")
	}

	oAppTasks = new NListBox {
		setCheckBoxes(True)
		addItems(["Task 1", "Task 2", "Task 3", "Task 4", "Task 5"])
		setChecked(2, True)
		setSize(160, 110)
		setSelectEvent("showInfo('Selected: ' + oAppTasks.itemText(oAppTasks.selected()))")
	}

	oAppColors = new NListBox {
		setMultiSelect(True)
		addItems(["Red", "Green", "Blue", "Orange", "Purple"])
		setItemColor(1, NAPP_COLOR_RED)
		setItemColor(2, NAPP_COLOR_GREEN)
		setItemColor(3, NAPP_COLOR_BLUE)
		setItemColor(4, NAPP_COLOR_ORANGE)
		setItemColor(5, NAPP_COLOR_PURPLE)
		setSize(160, 110)
	}

	oButton = new NButton("Show the checked tasks and the selected colors") {
		setClickEvent("showChecked()")
	}
	oAppInfo = new NLabel("") { setSizeText(copy("W", 45)) }

	oLayout = new NLayout(2, 7) {
		add(new NLabel("Country:"), 1, 1)    add(oAppCountry, 2, 1)
		add(new NLabel("City:"), 1, 2)       add(oAppCity, 2, 2)
		add(new NLabel("Fruit:"), 1, 3)      add(oFruit, 2, 3)
		add(new NLabel("Tasks:"), 1, 4)      add(new NLabel("Colors:"), 2, 4)
		add(oAppTasks, 1, 5)                 add(oAppColors, 2, 5)
		add(oButton, 2, 6)
		add(oAppInfo, 2, 7)
		setColumnMargin(1, 10)
		setRowsMargin(6)
		setMargin(15)
	}

	new NWindow("Lists") { setLayout(oLayout) show() }

func countryChanged
	fillCities(nappEvent().index())

func fillCities nCountry
	oAppCity.clear()
	oAppCity.addItems(aAppCities[nCountry])
	oAppCity.setSelected(1)

func showChecked
	cTasks = ""
	for nTask in oAppTasks.checkedItems()
		cTasks += oAppTasks.itemText(nTask) + " "
	next
	cColors = ""
	for nColor in oAppColors.selectedItems()
		cColors += oAppColors.itemText(nColor) + " "
	next
	showInfo("Checked: " + cTasks + "- Colors: " + cColors)

func showInfo cText
	oAppInfo.setText(cText)
