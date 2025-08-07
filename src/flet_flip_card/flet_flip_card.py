import flet as ft
from typing import Optional

class FlipCard(ft.Control):
    def __init__(
        self,
        front: Optional[ft.Control] = None,
        back: Optional[ft.Control] = None,
        flip_on_click: bool = True,
        initial_side: str = "front",
        flip_direction: str = "horizontal",
        **kwargs,
    ):
        super().__init__(**kwargs)
        self._front = front
        self._back = back
        self.flip_on_click = flip_on_click
        self.initial_side = initial_side
        self.flip_direction = flip_direction

    def _get_control_name(self):
        return "flet_flip_card"

    def build(self):
        result = []
        if self._front:
            self._front._name = "front"
            result.append(self._front)
        if self._back:
            self._back._name = "back"
            result.append(self._back)
        return result

    def flip(self):
        self.invoke_method("flip")

    def show_front(self):
        self.invoke_method("showFront")

    def show_back(self):
        self.invoke_method("showBack")
