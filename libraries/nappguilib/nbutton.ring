/*
	NButton: a push button (and the parent of NCheckBox, NRadioButton and NFlatButton)
*/

class NButton from NControl

	cText = ""

	func init cButtonText
		cText = cButtonText
		handle()
		button_text(pObject, cText)
		return self

	func createObject
		return button_push()

	func layoutAdd pLayout, nCol, nRow
		setCell(pLayout, nCol, nRow)
		layout_button(pLayout, handle(), nCol - 1, nRow - 1)

	func setText cButtonText
		cText = cButtonText
		button_text(handle(), cText)
		return self

	func text
		return cText

	func setAltText cButtonText
		# The text when the button is pressed (flat buttons)
		button_text_alt(handle(), cButtonText)
		return self

	func setTooltip cTooltip
		button_tooltip(handle(), cTooltip)
		return self

	func setFont oFont
		button_font(handle(), oFont.handle())
		return self

	func setImage oImage
		button_image(handle(), oImage.handle())
		return self

	func setAltImage oImage
		button_image_alt(handle(), oImage.handle())
		return self

	func setState nState
		# ekGUI_ON, ekGUI_OFF or ekGUI_MIXED
		button_state(handle(), nState)
		return self

	func state
		return button_get_state(handle())

	func setChecked lChecked
		if lChecked
			button_state(handle(), ekGUI_ON)
		else
			button_state(handle(), ekGUI_OFF)
		ok
		return self

	func isChecked
		return button_get_state(handle()) = ekGUI_ON

	func setButtonTag nTag
		button_tag(handle(), nTag)
		return self

	func buttonTag
		return button_get_tag(handle())

	func setVPadding nPadding
		button_vpadding(handle(), nPadding)
		return self

	func setClickEvent cCode
		button_OnClick(handle(), create_event(cCode))
		return self
