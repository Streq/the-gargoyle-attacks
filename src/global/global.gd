extends Node

var hiscore = 0.0 setget set_hiscore


func set_hiscore(val):
	if val>hiscore:
		hiscore = val
		$Label.text = "HISCORE:"+str(hiscore)


