for o in objects where matchPattern o.name pattern:"*BANGABANDHU*" do 
(
	o.name = substituteString o.name "BANGABANDHU" "GENERIC"
)