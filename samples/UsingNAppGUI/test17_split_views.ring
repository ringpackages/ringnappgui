# Split views: a list at the left, and at the right a text view above a drawing view
# Drag the dividers to change the sizes

load "nappguilib.ring"

oAppList = NULL
oAppText = NULL
oAppPreview = NULL
aAppNotes = [
	["Note 1", "The first note." + nl + "Split views have a divider that the user can move."],
	["Note 2", "The second note." + nl + "A split view can contain another split view."],
	["Note 3", "The third note." + nl + "Layouts and controls are added inside panels."]
]
nAppNote = 1

func main
	nappRun("createGUI()")

func createGUI
	oAppList = new NListBox { setSelectEvent("noteSelected()") }
	for aNote in aAppNotes oAppList.addItem(aNote[1]) next
	oAppList.setSelected(1)

	oAppText = new NTextView
	oAppPreview = new NView { setDrawEvent("drawPreview()") }

	# Right side: the text view above the preview
	oRight = new NSplitView(ekGUI_VERTICAL) {
		add(oAppText)
		add(oAppPreview)
		setPosition(0.6)
	}
	# Main split: the list at the left, the right side
	oMain = new NSplitView(ekGUI_HORIZONTAL) {
		add(oAppList)
		add(oRight)
		setPosition(0.3)
		setSize(600, 380)
	}

	oLayout = new NLayout(1, 1) { add(oMain, 1, 1) expandRow(1) expandColumn(1) }
	new NWindow("Split Views") { setResizable(True) setLayout(oLayout) show() }
	showNote()

func noteSelected
	nAppNote = oAppList.selected()
	if nAppNote = 0 nAppNote = 1 ok
	showNote()

func showNote
	oAppText.setText(aAppNotes[nAppNote][2])
	oAppPreview.update()

func drawPreview
	oCanvas = nappCanvas()
	oCanvas.clear(NAPP_COLOR_WHITE)
	oCanvas.setTextAlign(ekCENTER, ekCENTER)
	oCanvas.setTextColor(NAPP_COLOR_GRAY)
	oCanvas.text("Preview of " + aAppNotes[nAppNote][1], oCanvas.width() / 2, oCanvas.height() / 2)
