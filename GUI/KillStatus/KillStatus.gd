extends Panel

func add_text(t):
	$RichTextLabel.set_bbcode(t + $RichTextLabel.get_bbcode())
