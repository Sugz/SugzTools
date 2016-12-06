fn GetCoordSys  =
(
	case (getRefCoordSys()) of 
	(
		#world: print "1"
		#parent: print "2"
		#screen: print "3"
		#local: print "4"
		#working_pivot: print "5"
		#hybrid: print "6"
		#gimbal: print "7"
		#grid: print "8"
	)
)

callbacks.addscript #spacemodeChange "GetCoordSys()" id:#CoordSysCallback


callbacks.removeScripts #spacemodeChange id:#CoordSysCallback