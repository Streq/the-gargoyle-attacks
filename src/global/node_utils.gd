class_name NodeUtils

static func reparent(node: Node, to: Node)->void:
	node.get_parent().remove_child(node)
	to.add_child(node)
