/*
	NMenuItem: an item of a menu
*/

class NMenuItem

	pObject = NULL
	cText = ""

	func init cItemText
		cText = cItemText
		handle()
		menuitem_text(pObject, cText)
		return self

	func handle
		if isNull(pObject)
			pObject = menuitem_create()
		ok
		return pObject

	func setText cItemText
		cText = cItemText
		menuitem_text(handle(), cText)
		return self

	func text
		return cText

	func setClickEvent cCode
		menuitem_OnClick(handle(), create_event(cCode))
		return self

	func setKey nKey, nModifiers
		# The shortcut, like ekKEY_N with ekMKEY_CONTROL
		menuitem_key(handle(), nKey, nModifiers)
		return self

	func setSubMenu oMenu
		oMenu.detach()
		menuitem_submenu(handle(), oMenu.handle())
		return self

	func setEnabled lEnabled
		menuitem_enabled(handle(), lEnabled)
		return self

	func setVisible lVisible
		menuitem_visible(handle(), lVisible)
		return self

	func setChecked lChecked
		if lChecked
			menuitem_state(handle(), ekGUI_ON)
		else
			menuitem_state(handle(), ekGUI_OFF)
		ok
		return self

	func setImage oImage
		menuitem_image(handle(), oImage.handle())
		return self
