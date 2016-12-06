callbackItem = undefined
gc light:true


fn _plane = 
(
	$.lengthsegs = 1
	$.widthsegs = 1
)

fn _cylinder = 
	(
		$.heightsegs = 1
		$.sides = 12
	)


fn test ev nd = 
(
	if isCreatingObject() then 
	(
		case of 
		(
			(isCreatingObject Plane): _plane()
			(isCreatingObject Cylinder): _cylinder()
		)
		
		-- avoid the line to goes back to origin
		if not isCreatingObject Line then max modify mode
	)
)


callbackItem = NodeEventCallback mouseUp:true added:test 



-- 			obj = GetAnimByHandle nd[1]
-- 			case (classOf obj) of 
-- 			(
-- 				Plane: _sgz._pMan.SetPlane obj
-- 				Cylinder: _sgz._pMan.SetCylinder obj
-- 				Ngon: _sgz._pMan.SetNgon obj
-- 			)
-- 			max modify mode