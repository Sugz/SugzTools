--Destroy dialog if it already exists.
try(destroyDialog theRollout)catch()

--Create a rollout
rollout theRollout "The Rollout" width:300
(
	local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
	local _red = dnColor.FromArgb 255 150 40 40
	local _green = dnColor.FromArgb 255 30 100 30
	
	--Create the dotNet listview control
	dotNetControl requiredRelatedObjectsList "listView" width:240 height:357

	
	--Innitialize the listview control
	fn initListView =
	(
		--Setup the forms view
		requiredRelatedObjectsList.view=(dotNetClass "system.windows.forms.view").details
		requiredRelatedObjectsList.FullRowSelect = true
		requiredRelatedObjectsList.MultiSelect = false		
		requiredRelatedObjectsList.AllowColumnReorder = false
		requiredRelatedObjectsList.BackColor = dnColor.FromArgb 255 86 86 86
		requiredRelatedObjectsList.ForeColor = dnColor.FromArgb 255 225 225 225
		requiredRelatedObjectsList.HeaderStyle = requiredRelatedObjectsList.HeaderStyle.None
		
		requiredRelatedObjectsList.columns.add "Component" 235
-- 		requiredRelatedObjectsList.columns.add "3D Status" 60
	)

	
	--Adds rows of data to the listView
	fn populateList =
	(
		rows=#()		--Empty array to collect rows of data
		for x in objects do		--Loop through all the objects in the scene. 
		(
			li = dotNetObject "System.Windows.Forms.ListViewItem" x.name		--Create a listViewItem object and name it. 
-- 			li.subitems.add ((classOf x) as string)		--Add data to the second column.
			li.BackColor = _green
			append rows li		--Added the listViewItem to the rows array
		)
		
		requiredRelatedObjectsList.items.addRange rows		--Add the array of rows to the listView control. 
	)
	
	
	on theRollout open do
	(
		initListView()
		populateList()
	)
	
	
	
)

--Create a dialog and assign the rollout to it. 
createDialog theRollout