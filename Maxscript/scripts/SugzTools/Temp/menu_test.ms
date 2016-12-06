global _test
struct testStc
(
	
	fn test = 
	(
		print "this is a test"
	),
	
	fn AddMenus = 
	(
		if true then -- menuMan.registerMenuContext 0x714599c7 then
		(
			
			-- Create a new menu
			subMenu = menuMan.createMenu "SugzTools"
			-- create a menu item that calls the sample macroScript
			testItem = menuMan.createActionItem "MenuTest" "SugzTools"
			-- Add the item to the menu
			subMenu.addItem testItem -1

			-- Create a menu in the main menu bar that will include subMenu
			mainMenuBar = menuMan.getMainMenuBar()
			subMenuItem = menuMan.createSubMenuItem "SugzTools" subMenu
			mainMenuBar.addItem subMenuItem (mainMenuBar.numItems() + 1)
			
			-- redraw the menu bar with the new item
			menuMan.updateMenuBar()
		)
	),
	
	
	fn Run = 
	(
		AddMenus()
	),
	
	
	/* Macroscript declaration ############################################################################################*/
	macro =
	(
		macroScript MenuTest
			category:"SugzTools"
			toolTip:""
		(
			global _test
			on execute do 
			(
				if _test == undefined then fileIn "$userScripts\SugzTools\Temp\menu_test.ms"
				_test.test()
			)
			
		)
	)
	
)

_test = testStc()
_test.Run()