# A to-do list application: add, check, remove and save tasks (saved in a text file)

load "nappguilib.ring"

oAppWindow = NULL
oAppTask = NULL
oAppList = NULL
oAppStatus = NULL
cAppFile = "nappgui_todo.txt"
aAppTasks = []    # [cTask, lDone]

func main
	loadTasks()
	nappRun("createGUI()")

func createGUI
	oAppTask = new NEdit("") { setPlaceholder("New task (press Enter to add)") setChangeEvent("addTask()") }
	oAdd = new NButton("Add") { setClickEvent("addTask()") }
	oTop = new NLayout(2, 1) {
		add(oAppTask, 1, 1)  add(oAdd, 2, 1)
		expandColumn(1)
		setColumnMargin(1, 5)
	}

	oAppList = new NListBox {
		setCheckBoxes(True)
		setSize(360, 240)
		setSelectEvent("updateStatus()")
	}

	oRemove = new NButton("Remove") { setClickEvent("removeTask()") }
	oClearDone = new NButton("Remove Done") { setClickEvent("removeDone()") }
	oSave = new NButton("Save") { setClickEvent("saveTasks()") }
	oAppStatus = new NLabel("") { setSizeText(copy("W", 20)) }
	oButtons = new NLayout(5, 1) {
		add(oAppStatus, 1, 1)
		add(oRemove, 3, 1)  add(oClearDone, 4, 1)  add(oSave, 5, 1)
		expandColumn(2)
		setColumnMargin(3, 5)
		setColumnMargin(4, 5)
	}

	oLayout = new NLayout(1, 3) {
		add(oTop, 1, 1)
		add(oAppList, 1, 2)
		add(oButtons, 1, 3)
		setRowsMargin(8)
		setMargin(10)
		expandRow(2)
	}

	oAppWindow = new NWindow("To-Do List") {
		setResizable(True)
		setLayout(oLayout)
		setCloseEvent("closeApp()")
		addHotKey(ekKEY_S, ekMKEY_CONTROL, "saveTasks()")
		addHotKey(ekKEY_SUPR, ekMKEY_NONE, "removeTask()")
		show()
	}
	showTasks()

func showTasks
	readChecks()
	oAppList.clear()
	nCount = len(aAppTasks)
	for nTask = 1 to nCount
		oAppList.addItem(aAppTasks[nTask][1])
		oAppList.setChecked(nTask, aAppTasks[nTask][2])
		if aAppTasks[nTask][2]
			oAppList.setItemColor(nTask, NAPP_COLOR_GRAY)
		ok
	next
	updateStatus()

func readChecks
	# Copy the check boxes of the list to aAppTasks
	nCount = min([len(aAppTasks), oAppList.count()])
	for nTask = 1 to nCount
		aAppTasks[nTask][2] = oAppList.isChecked(nTask)
	next

func addTask
	cTask = trim(oAppTask.text())
	if cTask = "" return ok
	readChecks()
	aAppTasks + [cTask, False]
	oAppTask.setText("")
	showTasks()

func removeTask
	nTask = oAppList.selected()
	if nTask = 0 return ok
	readChecks()
	del(aAppTasks, nTask)
	showTasks()

func removeDone
	readChecks()
	for nTask = len(aAppTasks) to 1 step -1
		if aAppTasks[nTask][2] del(aAppTasks, nTask) ok
	next
	showTasks()

func updateStatus
	readChecks()
	nDone = 0
	for aTask in aAppTasks
		if aTask[2] nDone++ ok
	next
	oAppStatus.setText("Done: " + nDone + " of " + len(aAppTasks))

func loadTasks
	aAppTasks = []
	if not fexists(cAppFile)
		aAppTasks = [["Task 1", False], ["Task 2", True], ["Task 3", False]]
		return
	ok
	for cLine in str2list(read(cAppFile))
		if len(cLine) > 2
			aAppTasks + [substr(cLine, 3), left(cLine, 1) = "x"]
		ok
	next

func saveTasks
	readChecks()
	cData = ""
	for aTask in aAppTasks
		if aTask[2] cData += "x " else cData += "- " ok
		cData += aTask[1] + nl
	next
	write(cAppFile, cData)
	oAppStatus.setText("Saved")

func closeApp
	if nappConfirm(oAppWindow, "To-Do List", "Save the tasks before closing?")
		saveTasks()
	ok
	nappQuit()
