/* Variables ############################################################################################*/
local parentObjs = #()

/* UI ############################################################################################*/

timer clock interval:100
button instancesBtn "Instances" width:175 tooltip:"Select instances\n- Shift: Add instances to selection\n- Alt: Keep only one instance from selection\n- Ctrl: Select hidden objects"
button parentBtn "Parent" width:85 align:#left offset:[-7,0] tooltip:"Select direct parent\n- Shift: Add parent to selection\n- Alt: Deselect parent\n- Ctrl: Select hidden objects"
button parentsListBtn "Parents List" width:85 align:#right offset:[7,-26] tooltip:"Select parents list\n- Shift: Add parents list to selection\n- Alt: Deselect parents list\n- Ctrl: Select hidden objects"
button childrenBtn "Children" width:85 align:#left offset:[-7,0] tooltip:"Select direct children\n- Shift: Add children to selection\n- Alt: Deselect children\n- Ctrl: Select hidden objects"
button childrenListBtn "Children List" width:85 align:#right offset:[7,-26] tooltip:"Select children list\n- Shift: Add children list to selection\n- Alt: Deselect children list\n- Ctrl: Select hidden objects"

groupbox separatorGrp width:175 height:7 align:#center

dropdownlist parentDdl items:#("-- Add a Parent") width:97 align:#left offset:[-7,5]
button addParentBtn "+" width:22 align:#center offset:[20,-27]
button deleteParentBtn "-" width:22 align:#center offset:[42,-26] enabled:false
button setAsChildrenBtn "Link" width:30 align:#right offset:[7,-26] enabled:false tooltip:"Set selection as children of the parent object"

/*Functions ####################################################################################################################*/
/* Set the controls captions depending on the keyboard input  ***************************************************************************************************************************************************************/
fn SetControlsCaptionsFn =
(
	case of
	(
		(keyboard.shiftPressed and keyboard.controlPressed): -- #shift_ctrl: 
		(
			instancesBtn.caption = "+ All Instance"
			parentBtn.caption = "+ All Parent"
			parentsListBtn.caption = "+ All Parents List"
			childrenBtn.caption = "+ All Children"
			childrenListBtn.caption = "+ All Children List"
		)
		(keyboard.shiftPressed): -- #shift: 
		(
			instancesBtn.caption = "+ Instance"
			parentBtn.caption = "+ Parent"
			parentsListBtn.caption = "+ Parents List"
			childrenBtn.caption = "+ Children"
			childrenListBtn.caption = "+ Children List"
		)
		(keyboard.altPressed and keyboard.controlPressed): -- #alt_ctrl: 
		(
			parentBtn.caption = "- All Parent"
			parentsListBtn.caption = "- All Parents List"
			childrenBtn.caption = "- All Children"
			childrenListBtn.caption = "- All Children List"
		)
		(keyboard.altPressed): -- #alt: 
		(
			instancesBtn.caption = "Keep One Instance"
			parentBtn.caption = "- Parent"
			parentsListBtn.caption = "- Parents List"
			childrenBtn.caption = "- Children"
			childrenListBtn.caption = "- Children List"
		)
		(keyboard.controlPressed): -- #ctrl: 
		(
			instancesBtn.caption = "All Instances"
			parentBtn.caption = "All Parent"
			parentsListBtn.caption = "All Parents List"
			childrenBtn.caption = "All Children"
			childrenListBtn.caption = "All Children List"
		)
		(default): -- #none: 
		(
			instancesBtn.caption = "Instances"
			parentBtn.caption = "Parent"
			parentsListBtn.caption = "Parents List"
			childrenBtn.caption = "Children"
			childrenListBtn.caption = "Children List"
		)
	)
)


/* Update parentDdl items based on parentObjs ***************************************************************************************************************************************************************/
fn SetParentList = 
(
	if parentObjs.count != 0 then 
	(
		parentDdl.items = for obj in parentObjs collect obj.name
		deleteParentBtn.enabled = setAsChildrenBtn.enabled = true
	)
	else 
	(
		parentDdl.items = #("-- Add a Parent")
		deleteParentBtn.enabled = setAsChildrenBtn.enabled = false
	)
)


/*Events ####################################################################################################################*/
on clock tick do 
(
	SetControlsCaptionsFn()
)
	

/* Select instances  ***************************************************************************************************************************************************************/
on instancesBtn pressed do with undo "SugzTools: Select instances" on
(
	if not _sgz._sel.IsSelectionEmpty() then
	(
		case of 
		(
			(keyboard.shiftPressed and keyboard.controlPressed): selectMore (_sgz._sel.GetInstances selection getHidden:true)
			(keyboard.shiftPressed): selectMore (_sgz._sel.GetInstances selection getHidden:false)
			(keyboard.altPressed): select (_sgz._sel.DeleteInstanceFromSelection getHidden:false limitToSel: true)
			(keyboard.controlPressed): select (_sgz._sel.GetInstances selection getHidden:true)
			default: select (_sgz._sel.GetInstances selection getHidden:false)
		)
	)
)


/* Select drect parent ***************************************************************************************************************************************************************/
on parentBtn pressed do with undo "SugzTools: Select direct parent" on
(
	if not _sgz._sel.IsSelectionEmpty() then
	(
		case of 
		(
			(keyboard.shiftPressed and keyboard.controlPressed): selectMore (_sgz._sel.GetHierarchy parent:true getHidden:true)
			(keyboard.shiftPressed): selectMore (_sgz._sel.GetHierarchy parent:true)
-- 			(keyboard.altPressed and keyboard.controlPressed)): 
-- 			(keyboard.altPressed): 
			(keyboard.controlPressed): select (_sgz._sel.GetHierarchy parent:true getHidden:true)
			default: select (_sgz._sel.GetHierarchy parent:true)
		)
	)
)


/* Select parent list ***************************************************************************************************************************************************************/
on parentsListBtn pressed do with undo "SugzTools: Select parent list" on
(
	if not _sgz._sel.IsSelectionEmpty() then
	(
		case of 
		(
			(keyboard.shiftPressed and keyboard.controlPressed): selectMore (_sgz._sel.GetHierarchy parent:true getHidden:true all:true)
			(keyboard.shiftPressed): selectMore (_sgz._sel.GetHierarchy parent:true all:true)
-- 			(keyboard.altPressed and keyboard.controlPressed)): 
-- 			(keyboard.altPressed): 
			(keyboard.controlPressed): select (_sgz._sel.GetHierarchy parent:true getHidden:true all:true)
			default: select (_sgz._sel.GetHierarchy parent:true all:true)
		)
	)
)


/* Select direct children ***************************************************************************************************************************************************************/
on childrenBtn pressed do with undo "SugzTools: Select direct children" on
(
	if not _sgz._sel.IsSelectionEmpty() then
	(
		case of 
		(
			(keyboard.shiftPressed and keyboard.controlPressed): selectMore (_sgz._sel.GetHierarchy children:true getHidden:true)
			(keyboard.shiftPressed): selectMore (_sgz._sel.GetHierarchy children:true)
-- 			(keyboard.altPressed and keyboard.controlPressed)): 
-- 			(keyboard.altPressed): 
			(keyboard.controlPressed): select (_sgz._sel.GetHierarchy children:true getHidden:true)
			default: select (_sgz._sel.GetHierarchy children:true)
		)
	)
)


/* Select children list ***************************************************************************************************************************************************************/
on childrenListBtn pressed do with undo "SugzTools: Select children list" on
(
	if not _sgz._sel.IsSelectionEmpty() then
	(
		case of 
		(
			(keyboard.shiftPressed and keyboard.controlPressed): selectMore (_sgz._sel.GetHierarchy children:true getHidden:true all:true)
			(keyboard.shiftPressed): selectMore (_sgz._sel.GetHierarchy children:true all:true)
-- 			(keyboard.altPressed and keyboard.controlPressed)): 
-- 			(keyboard.altPressed): 
			(keyboard.controlPressed): select (_sgz._sel.GetHierarchy children:true getHidden:true all:true)
			default: select (_sgz._sel.GetHierarchy children:true all:true)
		)
	)
)


/* Add objects to parentObjs ***************************************************************************************************************************************************************/
on addParentBtn pressed do with undo "SugzTools: Add object to parent dropdownlist" on
(
	if not _sgz._sel.IsSelectionEmpty() then
	(
		_empty = if parentDdl.selected == "-- Add a Parent" then true else false
		for obj in getCurrentSelection() do appendIfUnique parentObjs obj
		SetParentList()
		if not _empty then parentDdl.selection += 1
	)
)


/* Remove an object from parentObjs ***************************************************************************************************************************************************************/
on deleteParentBtn pressed do with undo "SugzTools: Remove object from parent dropdownlist" on
(
	deleteItem parentObjs (parentDdl.selection)
	SetParentList()
	if parentDdl.selected == undefined then parentDdl.selection = parentDdl.items.count
)


/* Select the object in the dropdownlist ***************************************************************************************************************************************************************/
on parentDdl rightClick  do with undo "SugzTools: Select a parent from dropdownlist" on
(
	select parentObjs[parentDdl.selection]
)

/* Set selection a child to the item in the dropdownlist ***************************************************************************************************************************************************************/
on setAsChildrenBtn pressed do with undo "SugzTools: Set selection as children" on
(
	if not _sgz._sel.IsSelectionEmpty() and parentObjs.count != 0 then 
	(
		parentObj = parentObjs[parentDdl.selection]
		selection.parent = parentObj
		if parentObj.isHiddenInVpt then selection.IsHidden = true
	)
)
