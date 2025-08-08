from flet.core.constrained_control import ConstrainedControl

class FlipCard(ConstrainedControl):
    def __init__(self, front=None, back=None):
        super().__init__()
        self.front = front
        self.back = back

    def _get_control_name(self):
        return "flip_card"

    def _get_children(self):
        children = []
        if self.front:
            self.front._set_attr_internal("n", "front")
            children.append(self.front)
        if self.back:
            self.back._set_attr_internal("n", "back")
            children.append(self.back)
        return children
