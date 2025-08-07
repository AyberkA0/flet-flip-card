import flet as ft
from typing import Optional


class FletFlipCard(ft.Control):
    """
    A flip card control that automatically flips every 5 seconds.
    """

    def __init__(
        self,
        front: Optional[ft.Control] = None,
        back: Optional[ft.Control] = None,
        visible: bool = True,
        disabled: bool = False,
        data: Optional[str] = None,
    ):
        super().__init__()
        self._front = front
        self._back = back
        self.visible = visible
        self.disabled = disabled
        self.data = data

    def _get_control_name(self):
        return "flet_flip_card"

    def _get_children(self):
        children = []
        if self._front is not None:
            self._front._set_attr_internal("name", "front")
            children.append(self._front)
        if self._back is not None:
            self._back._set_attr_internal("name", "back")
            children.append(self._back)
        return children
