from enum import Enum
from typing import Any, Optional

from flet.core.constrained_control import ConstrainedControl

class FlipDirection(Enum):
    HORIZONTAL = "horizontal"
    VERTICAL = "vertical"

class FletFlipCard(ConstrainedControl):
    def __init__(
        self,
        front: Optional[ConstrainedControl] = None,
        back: Optional[ConstrainedControl] = None,
        direction: FlipDirection = FlipDirection.HORIZONTAL,
        **kwargs
    ):
        super().__init__(**kwargs)
        self.__front = front
        self.__back = back
        self.direction = direction

    def _get_control_name(self):
        return "flet_flip_card"

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
    def direction(self) -> FlipDirection:
        return self.__direction

    @direction.setter
    def direction(self, value: FlipDirection):
        self.__direction = value
        self._set_attr("direction", value.value)