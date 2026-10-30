/*
	NMenu: a menu (for the menu bar of a window, a sub menu or a popup menu)
*/

class NMenu

	pObject = NULL

	func init
		handle()
		return self

	func handle
		if isNull(pObject)
			pObject = menu_create()
			nappAddResource("menu", pObject)
		ok
		return pObject

	func add oItem
		menu_item(handle(), oItem.handle())
		return self

	func addSeparator
		menu_item(handle(), menuitem_separator())
		return self

	func count
		return menu_size(handle())

	func popup nX, nY
		# Show the menu at a screen position (use nappMousePosition())
		menu_launch(handle(), v2df(nX, nY))
		return self

	func popupAtMouse
		aMousePos = nappMousePosition()
		return popup(aMousePos[1], aMousePos[2])

	func detach
		# The menu is owned by a menu item (sub menu), so it's not destroyed at the end
		nappRemoveResource(handle())
