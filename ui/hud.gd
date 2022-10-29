extends CanvasLayer


var score = 0


func _ready() -> void:
	$Message.rect_pivot_offset = $Message.rect_size / 2


func show_message(text):
	$Message.text = text
	$MessageAnimationPlayer.play("show_message")


func hide():
	$ScoreBox.hide()
	$BonusBox.hide()


func show():
	$ScoreBox.show()
	$BonusBox.show()


func update_score(score, value):
	$Tween.interpolate_property(self, "score", score,
			value, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$ScoreAnimationPlayer.play("score")


func update_bonus(value):
	$BonusBox/Bonus.text = "%dx" % value
	if value > 1:
		$BonusAnimationPlayer.play("bonus")


func _on_tween_step(object, key, elapsed, value) -> void:
	$ScoreBox/HBoxContainer/Score.text = "%d" % int(value)
