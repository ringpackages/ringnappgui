# RingNAppGUI Extension

## Introduction

This extension wraps the NAppGUI library (Cross-Platform C SDK) for Ring.

NAppGUI URL: https://nappgui.com

The extension contains the NAppGUI functions (windows, layouts, controls, drawing, images, fonts, geometry, files and more), the `ek*` constants, and helper functions written for Ring: event parameters, event results, timers, list-based drawing, file dialogs and image files.

The functions and constants of this extension are loaded with the RingNAppGUI package, together with the classes and the `napp*()` functions from `ring/libraries/nappguilib`. To use the extension alone:

```ring
load "nappgui.ring"

osmain()

func create_gui
	window = window_create(ekWINDOW_STD)
	window_title(window, "Hello")
	layout = layout_create(1, 1)
	label = label_create()
	label_text(label, "Hello, World!")
	layout_label(layout, label, 0, 0)
	panel = panel_create()
	panel_layout(panel, layout)
	window_panel(window, panel)
	window_OnClose(window, create_event("close_app()"))
	window_show(window)

func close_app
	osapp_finish()
```

## Files

| File | Description |
|------|-------------|
| `ringnappgui.cf` | Configuration file for the Ring code generator |
| `ring_nappgui.c` | Generated C source code |
| `ring_nappgui.rh` | Generated constants |
| `nappgui.ring` | Loads the extension library and the constants |
| `gencode.bat`, `gencode.sh` | Generate `ring_nappgui.c` and `ring_nappgui.rh` from `ringnappgui.cf` |
| `buildvc_x64.bat` | Build using Visual C/C++ (64-bit) |
| `../libdepwin/nappgui` | The NAppGUI SDK: `src` (source code and headers), `lib/x64` (static libraries) and `LICENSE` |

## Building

The NAppGUI SDK (the source code, the headers and the static libraries for Windows x64) is in `ring/extensions/libdepwin/nappgui`. The RingNAppGUI package installs this folder, so the extension can be built even if the Ring folder doesn't contain it. Run the scripts from this folder (inside the Ring folder):

	gencode.bat
	buildvc_x64.bat

The extension is written to `ring/bin/ring_nappgui.dll`. It depends only on Windows system libraries and `ring.dll`.

## The Application

NAppGUI controls the main loop of the application:

| Function | Description |
|----------|-------------|
| `osmain()` | Start the application; calls the Ring function `create_gui()` |
| `osmain_sync(nSeconds)` | Like `osmain()`, and calls `update_gui()` each `nSeconds` |
| `osmain_run(cCreateCode, cDestroyCode, nSeconds, cUpdateCode)` | Start the application using any Ring code (`nSeconds` and `cUpdateCode` are used when `cUpdateCode` is not empty) |
| `osmain_time()`, `osmain_prevtime()` | The time (in seconds) of the current and the previous frame |
| `osapp_finish()` | End the application |

## Events

`create_event(cCode)` returns a listener that runs the Ring code `cCode` when the event happens. Use it with the `*_On*()` functions, for example `button_OnClick(button, create_event("click()"))`. Call `clean_events()` at the end of the application.

Inside an event, these functions read the event and return results to NAppGUI:

| Function | Description |
|----------|-------------|
| `event_params()` | A list of `[cName, vValue]` pairs, read using `aParams[:name]` (see the table below) |
| `event_object()` | The `Event` pointer (for the NAppGUI `event_*()` functions) |
| `event_sender_object()` | The control that sends the event |
| `event_result_bool(lValue)` | For the window close event (`False` keeps the window open), and the focus events |
| `event_result_number(nValue)` | A number result (like the number of rows of a table) |
| `event_result_text(cText, nCaretPos)` | The new text inside the filter event of edit boxes, combo boxes and text views |
| `event_result_cell(cText, nAlign)` | The text of a table cell (`ekGUI_EVENT_TBL_CELL`) |
| `event_result_size(nWidth, nHeight)` | The new size while the user resizes a window (`ekGUI_EVENT_WND_SIZING`) |

All the lists from `event_params()` contain `type` (`ekGUI_EVENT_*`). The other names depend on the event:

| Events | Parameters |
|--------|------------|
| `BUTTON`, `POPUP`, `LISTBOX`, `UPDOWN`, `TBL_HEADCLICK`, `MENU` | `index` (from 0), `state`, `text` |
| `SLIDER` | `pos` (0 to 1), `incr`, `step` |
| `LABEL`, `TXTFILTER`, `TXTCHANGE` | `text`, `cpos`, `len` |
| `FOCUS` | `focus` |
| `DRAW`, `OVERLAY` | `ctx` (the `DCtx` pointer for the `draw_*()` functions), `x`, `y`, `width`, `height` |
| `RESIZE`, `WND_SIZING`, `WND_SIZE` | `width`, `height` |
| `ENTER`, `MOVED`, `DOWN`, `UP`, `CLICK`, `DRAG` | `x`, `y`, `lx`, `ly`, `button`, `count`, `modifiers`, `tag` |
| `WHEEL` | `x`, `y`, `dx`, `dy`, `dz` |
| `KEYDOWN`, `KEYUP` | `key` (`ekKEY_*`), `modifiers` (`ekMKEY_*`) |
| `SCROLL` | `orient`, `scroll`, `cpos` |
| `WND_MOVED` | `x`, `y` |
| `WND_CLOSE` | `origin` (`ekGUI_CLOSE_*`) |
| `COLOR` | `color` |
| `TBL_BEGIN` | `stcol`, `edcol`, `strow`, `edrow` |
| `TBL_CELL` | `col`, `row` (from 0) |
| `TBL_ROWCLICK` | `sel`, `row` |
| `TBL_SEL` | `rows` (a list) |

## Helper Functions

| Function | Description |
|----------|-------------|
| `v2df_x(pV2Df)`, `v2df_y(pV2Df)` | The members of the `V2Df` values (like `window_get_origin()`) |
| `s2df_width(pS2Df)`, `s2df_height(pS2Df)` | The members of the `S2Df` values (like `window_get_size()`) |
| `r2df_x()`, `r2df_y()`, `r2df_width()`, `r2df_height()` | The members of the `R2Df` values |
| `view_size_list(pView)` | `[nWidth, nHeight]` |
| `view_viewport_list(pView)` | `[nX, nY, nWidth, nHeight]` of the visible area |
| `draw_polyline_list(pCtx, lClosed, aPoints)` | Lines between the `[x, y]` points |
| `draw_polygon_list(pCtx, nOp, aPoints)` | A polygon (`ekSTROKE`, `ekFILL`, `ekSKFILL`, `ekFILLSK`) |
| `draw_line_dash_list(pCtx, aPattern)` | Dashed lines (`[]` for solid lines) |
| `draw_fill_linear_list(pCtx, aColors, aStops, x0, y0, x1, y1)` | A linear gradient |
| `draw_text_size(pCtx, cText, nRefWidth)` | `[nWidth, nHeight]` of a text (`nRefWidth` = -1 for one line) |
| `font_text_size(pFont, cText, nRefWidth)` | `[nWidth, nHeight]` of a text |
| `font_families_list()` | The installed font families |
| `color_components(nColor)` | `[nRed, nGreen, nBlue, nAlpha]` |
| `color_html_text(nColor)` | `"#RRGGBB"` |
| `image_load(cFileName)` | An `Image` pointer, or `NULL` |
| `image_save(pImage, cFileName)` | Save using the image codec (`image_codec()`) |
| `comwin_open(pWindow, aTypes, cStartDir)`, `comwin_save(...)` | The file dialogs (`aTypes` like `["png", "jpg"]`); return the file name or `""` |
| `comwin_choose_color(pWindow, cTitle, x, y, nColor, pListener)` | The color dialog (`ekGUI_EVENT_COLOR`) |
| `tableview_selected_list(pTable)`, `tableview_select_list(pTable, aRows)` | The selected rows (from 0) |

## Notes

- Colors (`color_t`) and the enumerations (`align_t`, `gui_state_t`, `vkey_t`, ...) are numbers: `label_color(label, color_rgb(255, 0, 0))` and `button_state(button, ekGUI_ON)`.
- Structures like `V2Df`, `S2Df` and `R2Df` are returned as pointers: use `v2df(x, y)`, `s2df(width, height)` and `r2df(x, y, width, height)` to create them.
- Use `nullptr()` when a function accepts a `NULL` pointer, like `popup_add_elem(popup, "Item", nullptr())`.
- The rows, columns and indexes of the NAppGUI functions start from 0 (the classes of NAppGUILib use 1).
