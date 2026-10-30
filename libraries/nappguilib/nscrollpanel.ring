/*
	NScrollPanel: a panel with scroll bars (for content larger than the panel)
*/

class NScrollPanel from NPanel

	func createObject
		return panel_scroll(True, True)

	func scrollWidth
		return panel_scroll_width(handle())

	func scrollHeight
		return panel_scroll_height(handle())
