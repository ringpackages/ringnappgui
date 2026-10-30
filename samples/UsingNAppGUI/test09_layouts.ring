# Layouts: nested layouts, margins, alignment, expanding cells, resizable windows,
# showing/hiding rows and enabling/disabling controls

load "nappguilib.ring"

oAppForm = NULL
oAppDetails = NULL
oAppSave = NULL
lAppDetails = True

func main
	nappRun("createGUI()")

func createGUI
	# A form: labels at the left, text boxes that take the extra width
	oAppForm = new NLayout(2, 3) {
		add(new NLabel("Title:"), 1, 1)      add(new NEdit(""), 2, 1)
		add(new NLabel("Category:"), 1, 2)   add(new NPopUp { addItems(["General", "Work", "Home"]) }, 2, 2)
		add(new NLabel("Notes:"), 1, 3)      add(new NTextView, 2, 3)
		setVAlignCell(1, 3, ekTOP)
		setColumnMargin(1, 10)
		setRowsMargin(6)
		expandColumn(2)
		expandRow(3)
	}

	# A row of buttons aligned to the right
	oAppDetails = new NButton("Hide Notes") { setClickEvent("toggleNotes()") }
	oAppSave = new NButton("Save") { setClickEvent("nappMessage(NULL, 'Save', 'Saved')") }
	oLock = new NCheckBox("Lock") { setClickEvent("oAppSave.setEnabled(not nappEvent().isChecked())") }
	oButtons = new NLayout(4, 1) {
		add(oLock, 1, 1)
		add(oAppDetails, 3, 1)
		add(oAppSave, 4, 1)
		expandColumn(2)
		setColumnMargin(3, 5)
	}

	# A colored header
	oHeader = new NLabel("Resize the window: the notes box takes the extra space") {
		setColor(NAPP_COLOR_WHITE)
	}
	oHeaderLayout = new NLayout(1, 1) {
		add(oHeader, 1, 1)
		setMargin(8)
		setBackColor(NAPP_COLOR_BLUE)
	}

	oLayout = new NLayout(1, 3) {
		add(oHeaderLayout, 1, 1)
		add(oAppForm, 1, 2)
		add(oButtons, 1, 3)
		setRowMargin(1, 10)
		setRowMargin(2, 10)
		setMargin(10)
		expandRow(2)
	}
	oAppForm.setRowHeight(3, 120)

	new NWindow("Layouts") {
		setResizable(True)
		setLayout(oLayout)
		setSize(520, 330)
		center()
		show()
	}

func toggleNotes
	lAppDetails = not lAppDetails
	oAppForm.showRow(3, lAppDetails)
	oAppForm.update()
	if lAppDetails
		oAppDetails.setText("Hide Notes")
	else
		oAppDetails.setText("Show Notes")
	ok
