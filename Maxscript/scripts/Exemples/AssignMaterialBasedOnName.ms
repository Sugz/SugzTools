fn assignLampFn bool lamp_on lamp_off=
(
	for aMtlType in material.classes do 
	(
		for aMtl in (getClassInstances aMtlType processAllAnimatables:true) do
		(
			if bool 
				then (if aMtl.name == lamp_on then $.material = aMtl)
				else (if aMtl.name == lamp_off then $.material = aMtl)
			
		)
	)
)


assignLampFn true "Lamp_on" "Lamp_off"

