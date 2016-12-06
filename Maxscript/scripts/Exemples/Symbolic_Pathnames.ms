(
	fn printSymbolicPathnamesFn = 
	(
		for i =1 to symbolicPaths.numPaths() do format "% : %\n%\n\n" i (symbolicPaths.getPathName i) (symbolicPaths.getPathValue i)
	)
	
	fn checkUserPathnameFn userPathName = 
	(
		symbolicPaths.isUserPathName userPathName
	)
	
	fn removeUserPathnameFn userPathName = 
	(
		symbolicPaths.removeUserPath userPathName
	)

-- 	printSymbolicPathnamesFn()
-- 	checkUserPathnameFn "$sugzTools"
-- 	removeUserPathnamefn "$sugzTools"
)