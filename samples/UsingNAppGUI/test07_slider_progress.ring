# Sliders, progress bars and up/down buttons

load "nappguilib.ring"

oAppSlider = NULL
oAppProgress = NULL
oAppValue = NULL
oAppCounter = NULL
oAppVertical = NULL
oAppVerticalValue = NULL
nAppCounter = 5

func main
	nappRun("createGUI()")

func createGUI
	oAppSlider = new NSlider {
		setRange(0, 100)
		setValue(30)
		setMoveEvent("sliderMoved()")
	}
	oAppProgress = new NProgress
	oAppValue = new NLabel("") { setSizeText("Value: 000") }

	oSteps = new NSlider {
		setSteps(5)
		setTooltip("A slider with 5 steps")
	}

	oAppCounter = new NEdit("" + nAppCounter) { setAlign(ekRIGHT) setEditable(False) }
	oUpDown = new NUpDown { setClickEvent("upDown()") }
	oCounterLayout = new NLayout(2, 1) {
		add(oAppCounter, 1, 1)
		add(oUpDown, 2, 1)
		setColumnWidth(1, 60)
	}

	oAppVertical = new NVerticalSlider {
		setRange(-50, 50)
		setValue(0)
		setMoveEvent("oAppVerticalValue.setText('' + floor(oAppVertical.value()))")
	}
	oAppVerticalValue = new NLabel("0") { setSizeText("-000") }

	oBusy = new NProgress { setUndefined(True) }

	oLayout = new NLayout(3, 6) {
		add(new NLabel("Slider (0 to 100):"), 1, 1)  add(oAppSlider, 2, 1)  add(oAppValue, 3, 1)
		add(new NLabel("Progress:"), 1, 2)           add(oAppProgress, 2, 2)
		add(new NLabel("Steps:"), 1, 3)              add(oSteps, 2, 3)
		add(new NLabel("Counter:"), 1, 4)            add(oCounterLayout, 2, 4)
		add(new NLabel("Working:"), 1, 5)            add(oBusy, 2, 5)
		add(new NLabel("Vertical:"), 1, 6)           add(oAppVertical, 2, 6)  add(oAppVerticalValue, 3, 6)
		setHAlignCell(2, 4, ekLEFT)
		setColumnWidth(2, 250)
		setRowHeight(6, 100)
		setColumnsMargin(10)
		setRowsMargin(10)
		setMargin(15)
	}

	new NWindow("Slider and Progress") { setLayout(oLayout) show() }
	sliderMoved()

func sliderMoved
	nValue = floor(oAppSlider.value())
	oAppValue.setText("Value: " + nValue)
	oAppProgress.setValue(nValue / 100)

func upDown
	if nappEvent().isUp()
		nAppCounter++
	else
		nAppCounter--
	ok
	oAppCounter.setText("" + nAppCounter)
