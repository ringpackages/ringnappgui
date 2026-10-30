# Hello World using NAppGUILib (the classes and the napp*() functions)

load "nappguilib.ring"

oAppText = NULL
nAppClicks = 0

func main
	nappRun("createGUI()")

func createGUI
	oButton = new NButton("Click Me!") { setClickEvent("buttonClick()") }
	oAppText = new NTextView { setSize(250, 100) }

	oLayout = new NLayout(1, 3) {
		add(new NLabel("Hello!, I'm a label"), 1, 1)
		add(oButton, 1, 2)
		add(oAppText, 1, 3)
		setMargin(5)
		setRowsMargin(5)
	}

	new NWindow("Hello, World!") {
		setLayout(oLayout)
		setOrigin(100, 100)
		show()
	}

func buttonClick
	nAppClicks++
	oAppText.writeLine("Button click (" + nAppClicks + ")")
