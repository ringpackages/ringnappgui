# Drawing using the NAppGUI functions directly (the C extension):
# view_OnDraw(), event_params(), draw_*() and the ek* constants

load "nappgui.ring"

window = NULL
view = NULL
nMouseX = 150
nMouseY = 100

osmain()

func create_gui
	window = window_create(ekWINDOW_STDRES)
	window_title(window, "Low Level Drawing")
	window_OnClose(window, create_event("close_app()"))

	view = view_create()
	view_size(view, s2df(400, 260))
	view_OnDraw(view, create_event("draw_view()"))
	view_OnMove(view, create_event("mouse_moved()"))

	layout = layout_create(1, 1)
	layout_view(layout, view, 0, 0)
	layout_hexpand(layout, 0)
	layout_vexpand(layout, 0)
	panel = panel_create()
	panel_layout(panel, layout)
	window_panel(window, panel)
	window_show(window)

func draw_view
	# event_params() returns a list of [name, value] pairs
	aParams = event_params()
	ctx = aParams[:ctx]
	nWidth = aParams[:width]
	nHeight = aParams[:height]

	draw_clear(ctx, color_rgb(250, 250, 240))
	draw_line_color(ctx, color_rgb(200, 200, 200))
	draw_line_width(ctx, 1)
	for x = 0 to nWidth step 20
		draw_line(ctx, x, 0, x, nHeight)
	next
	for y = 0 to nHeight step 20
		draw_line(ctx, 0, y, nWidth, y)
	next

	draw_fill_color(ctx, color_rgba(255, 120, 0, 160))
	draw_circle(ctx, ekFILL, nMouseX, nMouseY, 30)
	draw_line_color(ctx, color_rgb(0, 0, 0))
	draw_line_width(ctx, 2)
	draw_polygon_list(ctx, ekSTROKE, [[20, 20], [120, 40], [60, 110]])

	draw_text_color(ctx, color_rgb(40, 40, 120))
	draw_text(ctx, "Mouse: " + floor(nMouseX) + ", " + floor(nMouseY), 10, nHeight - 25)

func mouse_moved
	aParams = event_params()
	nMouseX = aParams[:x]
	nMouseY = aParams[:y]
	view_update(view)

func close_app
	window_destroy(window)
	clean_events()
	osapp_finish()
