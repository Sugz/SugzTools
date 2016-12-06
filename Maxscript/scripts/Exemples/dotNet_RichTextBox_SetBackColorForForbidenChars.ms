try (destroyDialog dotNetRichTextbox) catch()

rollout dotNetRichTextbox "DotNet RichTextbox"
(
	
	local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
	local forbidenChars = #(" ","ä","ü","ö","!","§","$","%","&","=","?","ß","´","`","*","~","'",",","<",">","|","@","~","°","^","/","\ ","}","{","[","]","ê","è","é","â","á","à","ô","ó","ò","û","ú","ù")
	
	dotNetControl txt_textBox "RichTextBox" width:490 height:650 pos:[5,5]
	

	on dotNetRichTextbox open do 
	(
		txt_textBox.backcolor = dnColor.FromArgb 255 86 86 86								-- Define the background as the standard 3ds max textbox
		txt_textBox.Text = "This is an |exêmple@"													-- Define some text as exemple

		-- Changed the background color of all the ilegal charaters
		for i = 1 to txt_textBox.Text.Count do
		(
			for char in forbidenChars do 
			(
				if txt_textBox.Text[i] == char do 
				(
					txt_textBox.SelectionStart = i - 1;
					txt_textBox.SelectionLength = 1;
					txt_textBox.SelectionBackColor = dnColor.FromArgb 255 255 0 0
				)
			)
		)
	)
	
	
	-- Prevent user to enter an illegal character
	on txt_textBox KeyPress pressedKey do 
	(
		for char in forbidenChars do 
		(
			if pressedKey.KeyChar == char then 
				pressedKey.Handled = true
			else txt_textBox.SelectionBackColor = dnColor.FromArgb 255 86 86 86	
		)
	)


)
createDialog dotNetRichTextbox 500 700 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)