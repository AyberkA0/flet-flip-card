from typing import Optional
from flet.core.constrained_control import ConstrainedControl
from flet.core.types import OptionalNumber, OptionalControlEventCallable
from flet.core.control import Control

class FlipCardDirection:
    HORIZONTAL = "horizontal"
    VERTICAL = "vertical"

class FletFlipCard(ConstrainedControl):
    def __init__(
        self,
        show_front: Optional[bool] = True,
        direction: Optional[str] = FlipCardDirection.HORIZONTAL,
        speed: OptionalNumber = 500,  # milliseconds
        front: Optional[Control] = None,
        back: Optional[Control] = None,
        on_flip_done: OptionalControlEventCallable = None
    ):
        ConstrainedControl.__init__(self)
        self.show_front = show_front
        self.direction = direction
        self.speed = speed
        self.front = front
        self.back = back
        self.on_flip_done = on_flip_done

    def _get_control_name(self):
        return "flet_flip_card"

    @property
    def show_front(self) -> Optional[bool]:
        return self._get_attr("showFront", data_type="bool", def_value=True)

    @show_front.setter
    def show_front(self, value: Optional[bool]):
        self._set_attr("showFront", value)

    @property
    def direction(self) -> Optional[str]:
        return self._get_attr("direction")

    @direction.setter
    def direction(self, value: Optional[str]):
        if value not in (FlipCardDirection.HORIZONTAL, FlipCardDirection.VERTICAL):
            raise ValueError(
                f"Invalid direction '{value}'. Use FlipCardDirection.HORIZONTAL or FlipCardDirection.VERTICAL."
            )
        self._set_attr("direction", value)

    @property
    def speed(self) -> OptionalNumber:
        return self._get_attr("speed", data_type="float")

    @speed.setter
    def speed(self, value: OptionalNumber):
        self._set_attr("speed", value)

    @property
    def on_flip_done(self) -> OptionalControlEventCallable:
        return self._get_event_handler("flip_done")

    @on_flip_done.setter
    def on_flip_done(self, handler: OptionalControlEventCallable):
        self._add_event_handler("flip_done", handler)

    def _get_children(self):
        children = []
        if self.front is not None:
            self.front._set_attr_internal("n", "front")
            children.append(self.front)
        if self.back is not None:
            self.back._set_attr_internal("n", "back")
            children.append(self.back)
        return children

    def flip(self):
        self.invoke_method("flip")

    def show_front_side(self):
        self.invoke_method("show_front")

    def show_back_side(self):
        self.invoke_method("show_back")
