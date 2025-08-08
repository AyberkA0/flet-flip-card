from __future__ import annotations

from enum import Enum
from typing import Any, Callable, List, Optional

from flet import ControlEvent
from flet.core.constrained_control import ConstrainedControl
from flet.core.control import Control
from flet.core.types import OptionalNumber


class FlipDirection(str, Enum):
    HORIZONTAL = "horizontal"
    VERTICAL = "vertical"


class FlipInitialSide(str, Enum):
    FRONT = "front"
    BACK = "back"


class FlipCard(ConstrainedControl):
    """
    Flet FlipCard Control (Flet 0.28.3 uyumlu).
    - front/back: Flet kontrolleri
    - direction: "horizontal" | "vertical"
    - initial_side: "front" | "back"
    - flip_on_touch: bool
    - auto_flip_interval_ms: Optional[int]
    """

    def __init__(
        self,
        #
        # ConstrainedControl ortak
        #
        width: OptionalNumber = None,
        height: OptionalNumber = None,
        opacity: OptionalNumber = None,
        visible: Optional[bool] = None,
        tooltip: Optional[str] = None,
        left: OptionalNumber = None,
        top: OptionalNumber = None,
        right: OptionalNumber = None,
        bottom: OptionalNumber = None,
        expand: Optional[bool | int] = None,
        data: Any = None,
        #
        # FlipCard özel
        #
        front: Optional[Control] = None,
        back: Optional[Control] = None,
        direction: FlipDirection | str = FlipDirection.HORIZONTAL,
        initial_side: FlipInitialSide | str = FlipInitialSide.FRONT,
        flip_on_touch: bool = False,
        auto_flip_interval_ms: Optional[int] = None,
        #
        # Eventler
        on_flipped: Optional[Callable[[ControlEvent], None]] = None,
    ):
        ConstrainedControl.__init__(
            self,
            width=width,
            height=height,
            opacity=opacity,
            visible=visible,
            tooltip=tooltip,
            left=left,
            top=top,
            right=right,
            bottom=bottom,
            expand=expand,
            data=data,
        )

        self.front = front
        self.back = back
        self.direction = direction
        self.initial_side = initial_side
        self.flip_on_touch = flip_on_touch
        self.auto_flip_interval_ms = auto_flip_interval_ms

        if on_flipped is not None:
            self.on_flipped = on_flipped  # type: ignore[assignment]

    # ---- Control adı ----
    def _get_control_name(self) -> str:
        return "flet_flip_card"

    # ---- Çocuklar ----
    def _get_children(self) -> List[Control]:
        children: List[Control] = []
        if self.front:
            self.front._set_attr_internal("n", "front")
            children.append(self.front)
        if self.back:
            self.back._set_attr_internal("n", "back")
            children.append(self.back)
        return children

    # ---- Güncelleme ----
    def before_update(self):
        super().before_update()
        self._set_attr(
            "direction",
            self.direction.value if isinstance(self.direction, Enum) else self.direction,
        )
        self._set_attr(
            "initial_side",
            self.initial_side.value if isinstance(self.initial_side, Enum) else self.initial_side,
        )
        self._set_attr("flip_on_touch", bool(self.flip_on_touch))
        if self.auto_flip_interval_ms is None:
            self._set_attr("auto_flip_interval_ms", None)
        else:
            self._set_attr("auto_flip_interval_ms", int(self.auto_flip_interval_ms))

    # ---- Event ----
    @property
    def on_flipped(self):
        return self._get_event_handler("flipped")

    @on_flipped.setter
    def on_flipped(self, handler):
        self._add_event_handler("flipped", handler)

    # ---- Python -> Flutter method çağrıları ----
    def flip(self):
        self.invoke_method("flip")

    def show_front(self):
        self.invoke_method("show_front")

    def show_back(self):
        self.invoke_method("show_back")

    # ---- Özellikler ----
    @property
    def direction(self) -> str | FlipDirection:
        v = self._get_attr("direction")
        return FlipDirection(v) if isinstance(v, str) and v in ("horizontal", "vertical") else v

    @direction.setter
    def direction(self, value: str | FlipDirection):
        self._set_attr("direction", value.value if isinstance(value, FlipDirection) else value)

    @property
    def initial_side(self) -> str | FlipInitialSide:
        v = self._get_attr("initial_side")
        return FlipInitialSide(v) if isinstance(v, str) and v in ("front", "back") else v

    @initial_side.setter
    def initial_side(self, value: str | FlipInitialSide):
        self._set_attr("initial_side", value.value if isinstance(value, FlipInitialSide) else value)

    @property
    def flip_on_touch(self) -> bool:
        return bool(self._get_attr("flip_on_touch", False))

    @flip_on_touch.setter
    def flip_on_touch(self, value: bool):
        self._set_attr("flip_on_touch", bool(value))

    @property
    def auto_flip_interval_ms(self) -> Optional[int]:
        v = self._get_attr("auto_flip_interval_ms")
        return int(v) if v is not None else None

    @auto_flip_interval_ms.setter
    def auto_flip_interval_ms(self, value: Optional[int]):
        if value is None:
            self._set_attr("auto_flip_interval_ms", None)
        else:
            self._set_attr("auto_flip_interval_ms", int(value))
