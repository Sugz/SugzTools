(
	Fn SubObjLvlFn obj vert edge border face elem = 
	(
		isGoodSubObjLvl = false 
		if obj == 1 then if subObjectLevel == 0 do isGoodSubObjLvl = true
		if vert == 1 then if subObjectLevel == 1 do isGoodSubObjLvl = true
		if edge == 1 then if subObjectLevel == 2 do isGoodSubObjLvl = true
		if border == 1 then if subObjectLevel == 3 do isGoodSubObjLvl = true
		if face == 1 then if subObjectLevel == 4 do isGoodSubObjLvl = true
		if elem == 1 then if subObjectLevel == 5 do isGoodSubObjLvl = true
			
		isGoodSubObjLvl
	)
	
	if SubObjLvlFn 0 0 0 0 1 1 do print "ok"
	
)