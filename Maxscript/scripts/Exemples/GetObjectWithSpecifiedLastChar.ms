fn GetObjectsWithSpecifiedLastChar searchChar =
(
	_array = #()
	for o in objects do 
	(
		 _name = o.name
		lenght = _name.count
		if _name[lenght] == searchChar then append _array o
	)
	
	_array
	
)

select (GetObjectsWithSpecifiedLastChar "e")