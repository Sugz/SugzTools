(
	fn DeleteCustAttributes attr = 
	(
		try 
		(
			i = 1
			notFound = true 
			while notFound do 
			(
				for obj in selection do 
				(
					if (custattributes.getdef obj i).name == attr then 
					(
						custAttributes.delete obj i
						notFound = false
					)
				)
				
				i += 1
			)
			
		) catch()
		
		
	)
	
	DeleteCustAttributes #test2
-- 	DeleteCustAttributes #test3
)

