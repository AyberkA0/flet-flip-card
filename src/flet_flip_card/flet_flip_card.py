from enum import Enum
from typing import Optional
from flet.core.constrained_control import ConstrainedControl
from flet.core.control import OptionalNumber

class FlipDirection(Enum):
    HORIZONTAL = "horizontal"
    VERTICAL = "vertical"

class FlipInitialSide(Enum):
    FRONT = "front"
    BACK = "back"

class FlipCard(ConstrainedControl):
    def __init__(self, front=None, back=None, direction=FlipDirection.HORIZONTAL, initial_side=FlipInitialSide.FRONT, **kwargs):
        super().__init__(**kwargs)
        self.__front = front
        self.__back = back
        self.direction = direction
        self.initial_side = initial_side

    def _get_control_name(self):
        return "flip_card"

    def _get_children(self):
        children = []
        if self.__front:
            self.__front._set_attr_internal("n", "front")
            children.append(self.__front)
        if self.__back:
            self.__back._set_attr_internal("n", "back")
            children.append(self.__back)
        return children

    @property
    def direction(self): return self.__direction
    @direction.setter
    def direction(self, value): self.__direction = value; self._set_attr("direction", value.value)

    @property
    def initial_side(self): return self.__initial_side
    @initial_side.setter
    def initial_side(self, value): self.__initial_side = value; self._set_attr("initialSide", value.value)

    def flip(self): self._send_event("flip")
    def show_front(self): self._send_event("showFront")
    def show_back(self): self._send_event("showBack")
