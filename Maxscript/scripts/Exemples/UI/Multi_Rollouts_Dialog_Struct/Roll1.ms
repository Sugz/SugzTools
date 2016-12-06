rollout roll1 "Rollout 1"
(
	label lbl1 "This is a simple Label"
	button btn "Press me"
	label lbl2 "This is another label" offset:[0,20]
	
	on btn pressed do 
	(
		lbl1.text = "This one was easy ;)"
	)
)