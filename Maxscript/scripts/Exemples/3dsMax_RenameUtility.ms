--******************************************
-- Object Renaming Utility
-- 1.29.99 v1.06
-- David Humpherys
-- david@rezn8.com
--******************************************
MacroScript RenameObjects
	category:~RENAMEOBJECTS_CATEGORY~
	internalCategory:"Tools"
	tooltip:~RENAMEOBJECTS_TOOLTIP~ --pfb 24 mai 2003: added "..." after the name
	buttontext:~RENAMEOBJECTS_BUTTONTEXT~
(	
	global ReNameFloater
	local MyAry = #()
	local PickAry = #()
	local checked = false
	rollout renamerollout ~RENAME_OBJECTS~ width:216 height:300
	(
		radiobuttons objs "" pos:[48,12] width:129 height:16 labels:#(~SELECTED~, ~PICK~) columns:2
		checkbox base "" pos:[8,40] width:~BASE_WIDTH~ height:~BASE_HEIGHT~ checked:true
		edittext base_text ~BASE_NAME~ pos:~BASE_POSITION~ width:~BASE_TEXT_WIDTH~ height:~BASE_TEXT_HEIGHT~ enabled:true fieldwidth:~BASE_TEXT_FIELDWIDTH~
		checkbox prefix "" pos:~PREFIX_POSITION~ width:~PREFIX_WIDTH~ height:~PREFIX_HEIGHT~
		edittext pre_text ~PREFIX_TEXT~ pos:~PREFIX_TEXT_POSITION~ width:~PREFIX_TEXT_WIDTH~ height:~PREFIX_TEXT_HEIGHT~ enabled:true fieldwidth:~PREFIX_TEXT_FIELDWIDTH~ 
		spinner delPreSpin "" pos:~DELPRESPIN_POSITION~ width:~DELPRESPIN_WIDTH~ height:16 range:[0,20,0] type:#integer
		checkbox delPre ~REMOVE_FIRST~ pos:~REMOVE_FIRST_POSITION~ width:~REMOVE_FIRST_WIDTH~ height:~REMOVE_FIRST_HEIGHT~ 
		checkbox suffix "" pos:~SUFFIX_POSITION~ width:~SUFFIX_WIDTH~ height:~SUFFIX_HEIGHT~
		edittext suf_text ~SUF_TEXT_CAPTION~ pos:~SUF_TEXT_POSITION~ width:172 height:~SUF_TEXT_HEIGHT~ enabled:true fieldwidth:~SUF_TEXT_FIELDWIDTH~ 
		spinner delSufSpin "" pos:~DELSUFSPIN_POSITION~ width:~DELSUFSPIN_WIDTH~ height:16 range:[0,20,0] type:#integer
		checkbox delSuf ~DELSUF_REMOVE_LAST~ pos:~DELSUF_POSITION~ width:~DELSUF_WIDTH~ height:~DELSUF_HEIGHT~ 
		checkbox suf_num ~SUF_NUMBERED~ pos:~SUF_NUM_POSITION~ width:73 height:~SUF_NUM_HEIGHT~
		spinner base_num ~BASE_NUM_CAPTION~ pos:~BASE_NUM_POSITION~ width:~BASE_NUM_WIDTH~ height:16 range:[0,9999,0] type:#integer 
		spinner num_step ~NUM_STEP~ pos:~NUM_STEP_POSITION~ width:~NUM_STEP_WIDTH~ height:16 range:[-999,999,1] type:#integer 
		button do_rename ~DO_RENAME~ pos:~DO_RENAME_POSITION~ width:200 height:30
	
		label lbl16 ~DIGITS~ pos:~DIGITS_POSITION~ width:~DIGITS_WIDTH~ height:~DIGITS_HEIGHT~
		label lbl17 ~LBL17_DIGITS~ pos:~LBL17_POSITION~ width:~LBL17_WIDTH~ height:~LBL17_HEIGHT~
		on objs changed state do
		(
			if objs.state==2 then
			(
			-- CAL-06/21/02: use the previously picked object if selectByName is canceled
			MyAry =selectByName title:~PICK_OBJ_TO_RENAME~ buttonText:~MYARY_BUTTONTEXT~
			if MyAry == undefined then MyAry = PickAry else PickAry = MyAry
			print MyAry
			)
		)
/* CAL-07/16/02: leave them on all the times to be consistent with other checkboxes
		on base changed state do
		(
			if state==on then base_text.enabled=true
			if state==off then base_text.enabled=false
		)
		on prefix changed state do
		(
			if state==on then pre_text.enabled=true
			if state==off then pre_text.enabled=false
		)
		on suffix changed state do
		(
			if state==on then suf_text.enabled=true
			if state==off then suf_text.enabled=false
		)
*/
		on do_rename pressed do with undo on
		(	
			if objs.state==1 then MyAry=selection
			findErrors=0
			CountNum=1
			for i in MyAry do
			(			
				nodename = i.name
				if base.state==true then 
				(
					if base_text.text.count==0 then 
					(
						messagebox ~MSGBOX_BASE_NAME_FIELD_EMPTY~ Title:~MSGBOX_BASE_NAME_FIELD_TITLE~
						exit loop
					)
					
					nodename=base_text.text
				)
		
				if delpre.state==true then 
				(	
					if delprespin.value >= nodename.count then 
					(
						messagebox ~OBJ_RENAMED_NOT_ENOUGH_CHARS~ Title:~OBJ_RENAMED_NOT_ENOUGH_CHARS_TITLE~
						FindErrors=1
						exit loop
					)
					
					nodename=(substring nodename (delprespin.value+1) nodename.count)
				)
					
				if prefix.state==true then 
				(
					if Pre_text.text.count==0 then 
					(
						messagebox ~ADD_PREFIX_TEXT_FIELD_EMPTY~ Title:~ADD_PREFIX_TEXT_FIELD_EMPTY_TITLE~
						FindErrors=1
						exit loop
					)
					nodename=(pre_text.text + nodename)
				)
							
				if delsuf.state==true then 
				(
					if delsufspin.value>=nodename.count then 
					(
						messagebox ~OBJ_RENAMED_NOT_ENOUGH_CHARS_TO_REMOVE~ Title:~OBJ_RENAMED_NOT_ENOUGH_CHARS_TO_REMOVE_TITLE~
						FindErrors=1
						exit loop
					)
					nodename=(substring nodename 1 (nodename.count-delsufspin.value))
				)
					
				if suffix.state==true then 
				(
					if suf_text.text.count==0 then 
						(
							messagebox ~ADD_SUFFIX_TEXT_FIELD_EMPTY~ Title:~ADD_SUFFIX_TEXT_FIELD_EMPTY_TITLE~
							FindErrors=1
							exit loop
						)
					nodename=(nodename + suf_text.text)
				)
		
				if suf_num.state==true then 
				(
					NumberPad=((base_num.value + ((CountNum-1)*num_step.value)) as string)
					if NumberPad.count == 1 then NumberPad=("0"+NumberPad)
					nodename=nodename + NumberPad
					CountNum+=1
					-- print "hello"
				)
					
				i.name = nodename
			)
			-- Remove the comments from this line to close the rollout each time you rename
			--if findErrors == 0 then (closerolloutfloater ReNameFloater)
			
		)
		
		on renamerollout close do
		(
			checked = false
			updateToolbarButtons()
		)
	)
on execute do	
	(
		createDialog renamerollout 
		checked = true
	)

on closeDialogs do
	(
		destroyDialog renamerollout
	)
on isChecked return (checked)
)





