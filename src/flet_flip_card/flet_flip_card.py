from __future__ import annotations

from typing import List, Optional

from flet.core.constrained_control import ConstrainedControl
from flet.core.control import Control

class FlipCard(ConstrainedControl):
    def __init__(
        self,
        front: Optional[Control] = None,
        back: Optional[Control] = None,
    ):
        super().__init__()
        self.front = front
        self.back = back

    def _get_control_name(self) -> str:
        return "flet_flip_card"

    def _get_children(self) -> List[Control]:
        children: List[Control] = []
        if self.front:
            self.front._set_attr_internal("n", "front")
            children.append(self.front)
        if self.back:
            self.back._set_attr_internal("n", "back")
            children.append(self.back)
        return children

    def flip(self):
        self.invoke_method("flip")

    def show_front(self):
        self.invoke_method("show_front")

    def show_back(self):
        self.invoke_method("show_back")
