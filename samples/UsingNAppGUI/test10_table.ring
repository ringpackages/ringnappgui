# NTableView: columns, data, sorting by clicking the column titles, selection and search

load "nappguilib.ring"

oAppTable = NULL
oAppStatus = NULL
oAppSearch = NULL
aAppProducts = []
aAppSortColumn = [1, True]

func main
	nappRun("createGUI()")

func createGUI
	# Sample data: 1000 products (only the visible rows are drawn)
	for nProduct = 1 to 1000
		aAppProducts + ["Product " + nProduct, "Category " + (nProduct % 7 + 1),
				(nProduct * 37) % 500 + 10, (nProduct * 13) % 90 + 1]
	next

	oAppTable = new NTableView {
		addColumn("Name", 160)
		addColumn("Category", 120)
		addColumn("Price", 80)
		addColumn("Stock", 70)
		setColumnAlign(3, ekRIGHT)
		setColumnAlign(4, ekCENTER)
		setGrid(True, True)
		setMultiSelect(True)
		setData(aAppProducts)
		setSize(480, 300)
		setSelectEvent("rowsSelected()")
		setRowClickEvent("oAppStatus.setText('Clicked row: ' + nappEvent().row())")
		setHeaderClickEvent("sortTable()")
	}

	oAppSearch = new NEdit("") {
		setPlaceholder("Search by name (press Enter)")
		setChangeEvent("search()")
	}
	oAdd = new NButton("Add") { setClickEvent("addProduct()") }
	oDelete = new NButton("Delete") { setClickEvent("deleteProducts()") }
	oAppStatus = new NLabel("") { setSizeText(copy("W", 40)) }

	oTop = new NLayout(3, 1) {
		add(oAppSearch, 1, 1)  add(oAdd, 2, 1)  add(oDelete, 3, 1)
		expandColumn(1)
		setColumnsMargin(5)
	}

	oLayout = new NLayout(1, 3) {
		add(oTop, 1, 1)
		add(oAppTable, 1, 2)
		add(oAppStatus, 1, 3)
		setRowsMargin(6)
		setMargin(10)
		expandRow(2)
	}

	new NWindow("Table") { setResizable(True) setLayout(oLayout) show() }
	oAppStatus.setText("Rows: " + oAppTable.rowCount())

func rowsSelected
	aRows = oAppTable.selected()
	if len(aRows) = 1
		aRow = oAppTable.row(aRows[1])
		oAppStatus.setText(aRow[1] + " - Price: " + aRow[3])
	else
		oAppStatus.setText("Selected rows: " + len(aRows))
	ok

func sortTable
	nCol = nappEvent().index()
	if aAppSortColumn[1] = nCol
		aAppSortColumn[2] = not aAppSortColumn[2]
	else
		aAppSortColumn = [nCol, True]
	ok
	oAppTable.sortByColumn(nCol, aAppSortColumn[2])

func search
	cQuery = lower(trim(oAppSearch.text()))
	aFound = []
	for aProduct in aAppProducts
		if cQuery = "" or substr(lower(aProduct[1]), cQuery) > 0
			aFound + aProduct
		ok
	next
	oAppTable.setData(aFound)
	oAppStatus.setText("Found: " + len(aFound))

func addProduct
	nNumber = len(aAppProducts) + 1
	aProduct = ["Product " + nNumber, "Category 1", 100, 1]
	aAppProducts + aProduct
	oAppTable.addRow(aProduct)
	oAppTable.focusRow(oAppTable.rowCount())
	oAppTable.selectRows([oAppTable.rowCount()])

func deleteProducts
	aRows = oAppTable.selected()
	if len(aRows) = 0 return ok
	if not nappConfirm(NULL, "Delete", "Delete " + len(aRows) + " rows?") return ok
	for nIndex = len(aRows) to 1 step -1
		oAppTable.removeRow(aRows[nIndex])
	next
	oAppTable.deselectAll()
	oAppStatus.setText("Rows: " + oAppTable.rowCount())
