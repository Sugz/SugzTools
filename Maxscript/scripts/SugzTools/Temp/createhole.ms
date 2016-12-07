(
	selVert = polyop.getVertSelection $
	$.EditablePoly.ConvertSelection #Vertex #Edge
	edges = polyop.getEdgeSelection $
	subobjectLevel = 2
	macros.run "Editable Polygon Object" "EPoly_Connect2"
	
	
	polyop.setVertSelection $ selVert
	subobjectLevel = 1
	$.EditablePoly.ConvertSelection #Vertex #Edge
	_edge = $.selectedEdges[1].index
	
	polyop.setVertSelection $ selVert
	subobjectLevel = 1
	$.EditablePoly.ConvertSelection #Vertex #Face
	$.EditablePoly.tessellate #Face
	subobjectLevel = 4
	$.EditablePoly.delete #Face
	
-- 	polyop.setEd&geSelection $ edges
-- 	subobjectLevel = 3
)