global stc
(
	struct createRollMasterStc
	(
		-- define rollouts
		rollMaster = undefined,
		roll1 = undefined,
		roll2 = undefined,
		
		/* Define the UI *********************************************************************************************************************************/
		fn ui =
		(
			rollMaster = rollout rollMaster "Sugz" width:200 height:830
			(
				subrollout rollSub "" width:200 height:830
			)
			
			roll1 = include @"C:\Users\cplantec\Desktop\Scripting\GitHub\Maxscripts\Exemples\UI\Multi_Rollouts_Dialog_Struct\Roll1.ms"
			roll2 = include @"C:\Users\cplantec\Desktop\Scripting\GitHub\Maxscripts\Exemples\UI\Multi_Rollouts_Dialog_Struct\Roll2.ms"
			
			createDialog rollMaster
			AddSubRollout rollMaster.rollSub roll1
			AddSubRollout rollMaster.rollSub roll2
			rollMaster.rollSub.pos = [0,0]
			cui.RegisterDialogBar rollMaster
	-- 			cui.DockDialogBar rollMaster #cui_dock_left
			
		), -- end ui()
		
		
		/* Create or kill the UI *********************************************************************************************************************************/
		fn run = 
		(
			if rollMaster == undefined then 
				ui()
			else 
			(
				cui.UnRegisterDialogBar rollMaster 
				destroyDialog rollMaster
				rollMaster = undefined
				roll1 = undefined
				roll2 = undefined
			)
		) -- end run()
		
	) -- end struct
	
	stc = createRollMasterStc()
)






