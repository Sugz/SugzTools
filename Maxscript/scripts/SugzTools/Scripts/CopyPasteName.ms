try(destroyDialog ::Roll) catch()
Rollout Roll "Sugz"
(
	button copyBtn "Copy" width:150
	button pasteBtn "Paste" width:150
	
	on copyBtn pressed do
	(
		setclipboardText ($.name)
	)
	
	on pasteBtn  pressed do
	(
		$.name = getclipboardText()
	)
	
)
createDialog Roll 188 60 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)