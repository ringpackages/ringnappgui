# NTextView: text with fonts, sizes, styles, colors and alignment

load "nappguilib.ring"

oAppText = NULL
oAppEditor = NULL

func main
	nappRun("createGUI()")

func createGUI
	oAppText = new NTextView { setSize(420, 300) setEditable(False) }
	writeDocument()

	oAppEditor = new NTextView { setSize(420, 80) }
	oAppEditor.write("This text view can be edited. Type here, then click Count.")

	oCount = new NButton("Count") { setClickEvent("countWords()") }
	oCopy = new NButton("Copy All") { setClickEvent("copyAll()") }
	oButtons = new NLayout(2, 1) {
		add(oCount, 1, 1)  add(oCopy, 2, 1)
		setColumnsMargin(5)
	}

	oLayout = new NLayout(1, 3) {
		add(oAppText, 1, 1)
		add(oAppEditor, 1, 2)
		add(oButtons, 1, 3)
		setHAlignCell(1, 3, ekRIGHT)
		setRowsMargin(8)
		setMargin(10)
		expandRow(1)
	}

	new NWindow("Text View") { setResizable(True) setLayout(oLayout) show() }

func writeDocument
	oAppText {
		setFontSize(20) setFontStyle(ekFBOLD) setColor(NAPP_COLOR_BLUE)
		setAlign(ekCENTER)
		writeLine("Text View")

		setFontSize(13) setFontStyle(ekFNORMAL) setColor(NAPP_COLOR_BLACK)
		setAlign(ekLEFT)
		setParagraphSpace(4, 4)
		writeLine("A text view shows text with many fonts and colors.")

		write("Text can be ")
		setFontStyle(ekFBOLD) write("bold") setFontStyle(ekFNORMAL) write(", ")
		setFontStyle(ekFITALIC) write("italic") setFontStyle(ekFNORMAL) write(", ")
		setFontStyle(ekFUNDERLINE) write("underlined") setFontStyle(ekFNORMAL) write(" or ")
		setFontStyle(ekFSTRIKEOUT) write("crossed out") setFontStyle(ekFNORMAL) writeLine(".")

		setColor(NAPP_COLOR_RED) write("Red ")
		setColor(NAPP_COLOR_GREEN) write("Green ")
		setColor(NAPP_COLOR_BLUE) write("Blue ")
		setColor(NAPP_COLOR_BLACK) setBackColor(NAPP_COLOR_YELLOW) write("highlighted")
		setBackColor(NAPP_COLOR_WHITE) writeLine("")

		setFontFamily("monospace") setFontSize(12)
		writeLine("func main")
		writeLine("    ? 'Monospace text for code'")

		setFontFamily(nappSystemFontFamily()) setFontSize(13)
		setAlign(ekRIGHT)
		writeLine("Right aligned paragraph")
		setAlign(ekCENTER)
		setLineSpacing(1.5)
		writeLine("A centered paragraph with a larger line spacing." + nl + "The second line.")
	}

func countWords
	cText = trim(oAppEditor.text())
	nWords = 0
	if cText != ""
		nWords = len(split(substr(cText, nl, " "), " "))
	ok
	nappMessage(NULL, "Count", "Characters: " + len(cText) + nl + "Words: " + nWords)

func copyAll
	oAppEditor.selectText(0, -1)
	oAppEditor.copyText()
