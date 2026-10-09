from enum import Enum
from typing import Optional

import flet as ft

__all__ = ["FlipCard", "FlipCardDirection", "FlipCardSide"]


class FlipCardDirection(Enum):
    HORIZONTAL = "horizontal"
    VERTICAL = "vertical"


class FlipCardSide(Enum):
    FRONT = "front"
    BACK = "back"


@ft.control("flet_flip_card")
class FlipCard(ft.LayoutControl):
    front: Optional[ft.Control] = None
    back: Optional[ft.Control] = None
    direction: FlipCardDirection = FlipCardDirection.HORIZONTAL
    duration: ft.Number = 500
    initial_side: FlipCardSide = FlipCardSide.FRONT
    on_flip_done: Optional[ft.ControlEventHandler["FlipCard"]] = None

    @property
    def side(self) -> FlipCardSide:
        return getattr(self, "_current_side", self.initial_side)

    async def toggle(self):
        await self._invoke_method("flip")
        self._current_side = (
            FlipCardSide.BACK if self.side == FlipCardSide.FRONT else FlipCardSide.FRONT
        )

    async def show_front(self):
        if self.side != FlipCardSide.FRONT:
            await self.toggle()

    async def show_back(self):
        if self.side != FlipCardSide.BACK:
            await self.toggle()
