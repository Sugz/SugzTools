/*##############################################################################
SugzTools Extend Maxscript Library
Version 1.03
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
General functions to extend maxscript

# Required Components:
SugzTools Manager
SugzTools INI Manager

# Sources:
DeleteUserProp() by DenisT: http://forums.cgsociety.org/showthread.php?f=98&t=797430&
ArePtsEquivalent() by Vojtech Cada: http://creativescratchpad.blogspot.fr/2013/01/maxscript-float-comparison.html#
GetWinFolders() by TimHawker post : http://forums.cgsociety.org/archive/index.php?t-1090567.html

# ToDo:
rename library variable from _extMax to _mxs

# History:
1.03:
 - Add ArePtsEquivalent()
 - Add GetWinFolders()
 - Add GetHashTableValue(), GetHashTableKey(), GetHashTableKeyIndex(), GetHashTableValueIndex()
1.02:
 - Change script name from SugzTools Extend 3ds Max Library" to "SugzTools Extend Maxscript Library"
 - Add CutString()
 
*Use / Modify this script at your own risk !*
###############################################################################*/



struct ExtendMxsLibraryStc
(

	/* Delete a User Property ############################################################################################*/
	fn DeleteUserProp node prop = 
	(
		/*<Function>
		Description:
			Delete a User Property
		Arguments:
			<Node> node: the node to work on 
			<String> prop: the property to get rid
		Infos:
			DenisT post : http://forums.cgsociety.org/showthread.php?f=98&t=797430&
		</Function>*/
		
		if getUserProp node prop != undefined do
		(
			
			buff = (getUserPropBuffer node) as stringStream 
			newb = stringStream ""
			while not eof buff do
			(
				str = readLine buff
				if str != "" and not matchpattern str pattern:("*" + prop + "*=*") do format "%\n" str to:newb
			)
			
			setUserPropBuffer node (replace_LF_with_CRLF (newb as string))
		)
	),
	
	
	
	/* Print all actionMan ############################################################################################*/
	fn PrintActionMan = 
	(
		/*<Function>
		Description:
			Print all actionMan
		</Function>*/

		for i = 1 to actionMan.numActionTables-1 do 
		(
			atbl = actionMan.getActionTable i
			format "% ID:% Name:'%' ContextID:% ContextName:'%' NumActionItems:%\n" i atbl.id atbl.name atbl.contextID atbl.contextName atbl.numActionItems
			for j = 1 to atbl.numActionItems do
			(
				aitm = atbl.getActionItem j
				aitm.getDescription &desc 
				aitm.getCategory &cat
				aitm.getButtonText &btn
				aitm.getMenuText &mnu
				hasicon = aitm.hasIcon()
				if hasicon then
				(
					aitm.getIconFileName &iconfile 
					iconfile = filenamefrompath iconfile 
					iconindex = aitm.getIconIndex()
					format "\t% ID:% Desc:'%' Cat:'%' BtnTxt:'%' MnuTxt:'%' Icon:[%,%] \n" j aitm.id desc cat btn mnu iconfile iconindex
				)
				else
					format "\t% ID:% Desc:'%' Cat:'%' BtnTxt:'%' MnuTxt:'%'\n" j aitm.id desc cat btn mnu 
			)
		)
	),
	
	
	
	/* Return the current check state of the specified ActionMan ############################################################################################*/
	fn GetActionManState table id =
	(
		/*<Function>
		Description:
			Return the current check state of the specified ActionMan
		Arguments:
			<String> table: the name of the action table to search for 
			<String> id: the id of the action item to search for in the given action table
		Return:
			<Bool> The current state of the selection outline action item
		</Function>*/
		
		for i = 1 to actionMan.numActionTables - 1 do
		(
			aTable = actionMan.getActionTable i
			if aTable.name == table then 
			(
				for j = 1 to aTable.numActionItems do
				(
					aItem = aTable.getActionItem j
					if aItem.id == id  then return aItem.isChecked
				)
			)
		)
	
	),
	
	
	
	/* Delete a folder ############################################################################################*/
	fn DeleteFolder _path =
	(
		/*<Function>
		Description:
			Delete a folder
		Arguments:
			<String> _path: the folder to delete
		</Function>*/

		local sioDir = dotNetClass "System.IO.Directory"
		if (SIODir.Exists _path) then SIODir.Delete (_path) true
	),


	
	/* Display a temp prompt ############################################################################################*/
	fn Prompt str =
	(
		/*<Function>
		Description:
			Display a temp prompt
		Arguments:
			<String> str: the string to prompt
		</Function>*/
		
		displayTempPrompt ("SugzTools: " + str) (execute (getIniSetting _sgz._ini "Common" "promptTime") * 1000)
	
	),
	
	
	
	/* Convert a value to an Array ############################################################################################*/
	fn AsArray input =
	(
		/*<Function>
		Description:
			Convert a value to an array
		Arguments:
			<Var>  input: a variable that need to be an array
		Return:
			Array<Var> the input as array
		</Function>*/
		
		if not isKindOf input array then #(input) else input
	
	),


	/* Convert a value to a BitArray ############################################################################################*/
	fn AsBitArray input =
	(
		/*<Function>
		Description:
			Convert a value to an array
		Arguments:
			<Var>  input: a variable that need to be an array
		Return:
			Array<Var> the input as array
		</Function>*/
		
		case (classOf input) of 
		(
			Integer: #{input}
			array: input as BitArray
			BitArray: input
		)
	
	),
	
	
	
	/* Sort a list of integer ############################################################################################*/
	fn SortIntegers intList = 
	(
		/*<Function>
		Description:
			Sort a list of integer
		Arguments:
			Array<Integer> intList : the list of integer that need to be sorted
		Return:
			Array<Integer> intList : the sorted list of integer
		</Function>*/
		
		function CompareValues val1 val2 = return (val1 as integer) - (val2 as integer)
		qsort intList CompareValues
		
		intList
	),
	
	
	
	/* Sort a list of string ############################################################################################*/
	fn SortStrings strList = 
	(
		/*<Function>
		Description:
			Sort a list of string
		Arguments:
			Array<String> strList : the list of string that need to be sorted
		Return:
			Array<String> strList : the sorted list of string
		</Function>*/
		
		function CompareStrings str1 str2 = stricmp str1 str2
		qSort strList CompareStrings
		
		strList
	),
	
	
	
	/* Sort a list of object by name ############################################################################################*/
	fn SortObjects objs =
	(
		/*<Function>
		Description:
			Sort a list of object by name
		Arguments:
			Array<Node> objs: the objects list to be sorted 
		Return:
			Array<Node> objs: the sorted objects list
		</Function>*/
		
		function compareNames obj1 obj2 = stricmp obj1.name obj2.name
		qSort objs compareNames
		
		objs
	),
	
	
	
	/* Check if two point3 are equivalent ############################################################################################*/
	fn ArePtsEquivalent p1 p2 eps:1e-3 = 
	(
		/*<Function>
		Description:
			Check if two point3 are equivalent
		Arguments:
			<Point3> p1: the first point3 value
			<Point3> p2: the second point3 value
			<Float> eps: the value to consider the two point3 are equivalent <Optional> 
		Return:
			<Bool> Wheter the two Point3 values are equivalent or not
		Infos:
			Code from Vojtech Cada: http://creativescratchpad.blogspot.fr/2013/01/maxscript-float-comparison.html#
		</Function>*/
		
		distance p1 p2 < eps
	),
	
	
	
	/* Cut a string that its displayed width isn't superior to a given value ############################################################################################*/
	fn CutString str width location:#left =
	(
		/*<Function>
		Description:
			Cut a string that its displayed width isn't superior to a given value
		Arguments:
			<String> str: the string to cut
			<Integer>width: the maximum widh of the cut string
			<Name> location: decide if the string have to be cut from the begining or the end
		Return:
			<String> cutString: the cut string
		</Function>*/
		
		_cutString = str
		
		if (GetTextExtent str)[1] > width then 
		(
			case location of
			(
				#left: 
				(
					i = 2
					_cutString = str[1]
					while (GetTextExtent _cutString)[1] < width do 
					(
						_cutString += str[i]
						i += 1
					)
					
					_cutString += "..."
				)
				
				#center:
				(
					i = 1
					_cutString = str[str.count / 2]
					left = true
					while (GetTextExtent _cutString)[1] < width - 12 do 
					(
						if left then
						(
							_cutString = str[(str.count / 2) - i] + _cutString
							left = false
						)
						else 
						(
							_cutString += str[(str.count / 2) + i]
							i += 1
							left = true
						)
					)
					
					_cutString = "..." + _cutString + "..."
					
				)
				
				#right: 
				(
					i = str.count - 1
					_cutString = str[str.count]
					while (GetTextExtent _cutString)[1] < width do 
					(
						_cutString = str[i] + _cutString
						i -= 1
					)
					
					_cutString = "..." + _cutString
				)
			)
		)
	
		_cutString
	),
	
	
	
	/* Get all windows and special folders ############################################################################################*/
	fn GetWinFolders folder =
	(
		/*<Function>
		Description:
			Get all windows and special folders
		Arguments:
			<Name> folder: the name of the special folder
		Return:
			<String> the path of the special folder
		Infos:
			Code base on TimHawker post : http://forums.cgsociety.org/archive/index.php?t-1090567.html
			Environment.SpecialFolder Enumeration: https://msdn.microsoft.com/en-us/library/system.environment.specialfolder(v=vs.110).aspx
		</Function>*/
		
		sysEnv = dotNetClass "System.Environment"
		folders = dotNetClass "System.Environment+specialFolder"
		
		case folder of 
		(
			#AdminTools: return sysEnv.getFolderPath folders.AdminTools
			#ApplicationData: return sysEnv.getFolderPath folders.ApplicationData
			#CDBurning: return sysEnv.getFolderPath folders.CDBurning
			#CommonAdminTools: return sysEnv.getFolderPath folders.CommonAdminTools
			#CommonApplicationData: return sysEnv.getFolderPath folders.CommonApplicationData
			#CommonDesktopDirectory: return sysEnv.getFolderPath folders.CommonDesktopDirectory
			#CommonDocuments: return sysEnv.getFolderPath folders.CommonDocuments
			#CommonMusic: return sysEnv.getFolderPath folders.CommonMusic
			#CommonOemLinks: return sysEnv.getFolderPath folders.CommonOemLinks
			#CommonPictures: return sysEnv.getFolderPath folders.CommonPictures
			#CommonProgramFiles: return sysEnv.getFolderPath folders.CommonProgramFiles
			#CommonProgramFilesX86: return sysEnv.getFolderPath folders.CommonProgramFilesX86
			#CommonPrograms: return sysEnv.getFolderPath folders.CommonPrograms
			#CommonStartMenu: return sysEnv.getFolderPath folders.CommonStartMenu
			#CommonStartup: return sysEnv.getFolderPath folders.CommonStartup
			#CommonTemplates: return sysEnv.getFolderPath folders.CommonTemplates
			#CommonVideos: return sysEnv.getFolderPath folders.CommonVideos
			#Cookies: return sysEnv.getFolderPath folders.Cookies
			#Desktop: return sysEnv.getFolderPath folders.Desktop
			#DesktopDirectory: return sysEnv.getFolderPath folders.DesktopDirectory
			#Favorites: return sysEnv.getFolderPath folders.Favorites
			#Fonts: return sysEnv.getFolderPath folders.Fonts
			#History: return sysEnv.getFolderPath folders.History
			#InternetCache: return sysEnv.getFolderPath folders.InternetCache
			#LocalApplicationData: return sysEnv.getFolderPath folders.LocalApplicationData
			#LocalizedResources: return sysEnv.getFolderPath folders.LocalizedResources
			#MyComputer: return sysEnv.getFolderPath folders.MyComputer
			#MyDocuments: return sysEnv.getFolderPath folders.MyDocuments
			#MyMusic: return sysEnv.getFolderPath folders.MyMusic
			#MyPictures: return sysEnv.getFolderPath folders.MyPictures
			#MyVideos: return sysEnv.getFolderPath folders.MyVideos
			#NetworkShortcuts: return sysEnv.getFolderPath folders.NetworkShortcuts
			#Personal: return sysEnv.getFolderPath folders.Personal
			#PrinterShortcuts: return sysEnv.getFolderPath folders.PrinterShortcuts
			#ProgramFiles: return sysEnv.getFolderPath folders.ProgramFiles
			#ProgramFilesX86: return sysEnv.getFolderPath folders.ProgramFilesX86
			#Programs: return sysEnv.getFolderPath folders.Programs
			#Recent: return sysEnv.getFolderPath folders.Recent
			#Resources: return sysEnv.getFolderPath folders.Resources
			#SendTo: return sysEnv.getFolderPath folders.SendTo
			#StartMenu: return sysEnv.getFolderPath folders.StartMenu
			#Startup: return sysEnv.getFolderPath folders.Startup
			#System: return sysEnv.getFolderPath folders.System
			#SystemX86: return sysEnv.getFolderPath folders.SystemX86
			#Templates: return sysEnv.getFolderPath folders.Templates
			#UserProfile: return sysEnv.getFolderPath folders.UserProfile
			#Windows: return sysEnv.getFolderPath folders.Windows
		)
		
	),
	
	
	
	/* Return the value from a key in a maxscript hashtable ############################################################################################*/
	fn GetHashTableValue ht key =
	(
		/*<Function>
		Description:
			Return the value from a key in a maxscript hashtable
		Arguments:
			Array<Array<Var, Var>> ht: the mascript hashtable
			<Var> key: the key to search in the hashtable
		Return:
			<Var> value: the value corresponding to the key
		Infos:
			Maxscript hashtable #(#(key, value), #(key, value), ...)
		</Function>*/
		
		value = undefined
		for item in ht while value == undefined do if item[1] == key then value = item[2]
		
		value
	),
	
	
	
	/* Return the value from a key in a maxscript hashtable ############################################################################################*/
	fn GetHashTableKey ht value =
	(
		/*<Function>
		Description:
			Return the key from a value in a maxscript hashtable
		Arguments:
			Array<Array<Var, Var>> ht: the mascript hashtable
			<Var> value: the value to search in the hashtable
		Return:
			<Var> key: the key corresponding to the value
		Infos:
			Maxscript hashtable #(#(key, value), #(key, value), ...)
		</Function>*/
		
		key = undefined
		for item in ht while key == undefined do if item[2] == value then key = item[1]
		
		key
	),
	
	
	
	/* Return the value from a key in a maxscript hashtable ############################################################################################*/
	fn GetHashTableKeyIndex ht key =
	(
		/*<Function>
		Description:
			Return the index from a key in a maxscript hashtable
		Arguments:
			Array<Array<Var, Var>> ht: the mascript hashtable
			<Var> key: the key to search in the hashtable
		Return:
			<Var> index: the index corresponding to the key
		Infos:
			Maxscript hashtable #(#(key, value), #(key, value), ...)
		</Function>*/
		
		index = -1
		for i = 1 to ht.count while index == -1 do if ht[i][1] == key then index = i
		
		index
	),
	
	
	
	/* Return the value from a key in a maxscript hashtable ############################################################################################*/
	fn GetHashTableValueIndex ht value =
	(
		/*<Function>
		Description:
			Return the index from a value in a maxscript hashtable
		Arguments:
			Array<Array<Var, Var>> ht: the mascript hashtable
			<Var> value: the value to search in the hashtable
		Return:
			<Var> index: the index corresponding to the value
		Infos:
			Maxscript hashtable #(#(key, value), #(key, value), ...)
		</Function>*/
		
		index = -1
		for i = 1 to ht.count while index == -1 do if ht[i][2] == value then index = i
		
		index
	),
	
	
	
	/* Set the HeapSize ############################################################################################*/
	fn SetHeapSize value =
	(
		/*<Function>
		Description:
			Set the HeapSize
		Arguments:
			<Integer> value: the minimum heapsize to reach
		</Function>*/
		
		while heapSize < value do heapSize += 100000
	)
	
)
