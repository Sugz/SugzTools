(
	fn DoMathFn = 
	(
		(1 + 15 / 523.0) * 51
	)
	
	startTime = timeStamp()
	for i = 1 to 100000 do DoMathFn()
	endTime = timeStamp()
	
	elapsedTime = endTime - startTime
	format "Elapsed Time: %\n" elapsedTime
)