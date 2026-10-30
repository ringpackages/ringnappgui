# NAppGUILib version
NAPPGUILIB_VERSION = "1.0.0"

# Colors (0xAABBGGRR numbers made by color_rgb(), used by the setColor() methods and NCanvas)
NAPP_COLOR_BLACK = color_rgb(0, 0, 0)
NAPP_COLOR_WHITE = color_rgb(255, 255, 255)
NAPP_COLOR_RED = color_rgb(220, 40, 40)
NAPP_COLOR_GREEN = color_rgb(40, 160, 70)
NAPP_COLOR_BLUE = color_rgb(40, 90, 200)
NAPP_COLOR_YELLOW = color_rgb(240, 200, 30)
NAPP_COLOR_ORANGE = color_rgb(240, 130, 30)
NAPP_COLOR_PURPLE = color_rgb(130, 60, 180)
NAPP_COLOR_CYAN = color_rgb(30, 170, 200)
NAPP_COLOR_GRAY = color_rgb(128, 128, 128)
NAPP_COLOR_LIGHTGRAY = color_rgb(220, 220, 220)
NAPP_COLOR_DARKGRAY = color_rgb(64, 64, 64)
NAPP_COLOR_TRANSPARENT = color_rgba(0, 0, 0, 0)

# Interval (in seconds) of the main loop used by nappRunTimer() when no interval is given
NAPP_TIMER_INTERVAL = 0.02

# window.modal() returns NAPP_MODAL_CLOSED + the close origin (ekGUI_CLOSE_ESC, ekGUI_CLOSE_INTRO,
# ekGUI_CLOSE_BUTTON) when the user closes a modal window without using its buttons
NAPP_MODAL_CLOSED = 1000

# Registries (the library keeps numbers and pointers here, not objects)

	# [nID, pWindow, cCloseCode, lModal, lMain, pMenuBar]
	aNAppWindows = []

	# [nID, aRows, aAligns]
	aNAppTables = []

	# [nID, nInterval, nNextTime, cCode, lRunning]
	aNAppTimers = []

	# [cKind, pPointer] fonts, images and menus destroyed by nappCleanup()
	aNAppResources = []

	# Window IDs of the open modal windows (the last one is the active window)
	aNAppModalStack = []

	# The code executed at each frame of the main loop (see nappSetUpdateEvent())
	cNAppUpdateCode = ""
	lNAppUpdating = False

	# The last ID given to a window, a table or a timer
	nNAppLastID = 0

	# The families of the system fonts (see nappSystemFontFamily())
	cNAppSystemFamily = ""
	cNAppMonospaceFamily = ""

	# True while the application is running (between nappRun() and nappCleanup())
	lNAppRunning = False
