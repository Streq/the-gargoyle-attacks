extends Area2D


var score = 0



func _on_goal_area_body_entered(body):
	body.queue_free()
	score += 1
	var scorelabel = Group.get_one("score")
	scorelabel.text = "score:"+str(score)
	Global.hiscore = score
