import asyncio
from typing import Literal, Optional

import flet as ft


@ft.control("flet_flip_card")
class FlipCard(ft.Control):
    """
    A flip card control that supports front and back sides.
    """

    def __init__(
        self,
        front: Optional[ft.Control] = None,
        back: Optional[ft.Control] = None,
        initial_side: Literal["front", "back"] = "back",
        direction: Literal["horizontal", "vertical"] = "horizontal",
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.initial_side = initial_side
        self.direction = direction
        if front:
            self._set_attr("front", True)
            self.controls.append(front)
        if back:
            self._set_attr("back", True)
            self.controls.append(back)

    initial_side: Literal["front", "back"]
    direction: Literal["horizontal", "vertical"]

    async def flip_async(self, timeout: Optional[float] = 10):
        await self._invoke_method_async("flip", timeout=timeout)

    def flip(self, timeout: Optional[float] = 10):
        asyncio.create_task(self.flip_async(timeout))

    async def show_front_async(self, timeout: Optional[float] = 10):
        await self._invoke_method_async("showFront", timeout=timeout)

    def show_front(self, timeout: Optional[float] = 10):
        asyncio.create_task(self.show_front_async(timeout))

    async def show_back_async(self, timeout: Optional[float] = 10):
        await self._invoke_method_async("showBack", timeout=timeout)

    def show_back(self, timeout: Optional[float] = 10):
        asyncio.create_task(self.show_back_async(timeout))
