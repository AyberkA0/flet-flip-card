from __future__ import annotations
from typing import Any, Optional, Callable
from enum import Enum

from flet.core.constrained_control import ConstrainedControl
from flet.core.control import OptionalNumber
from flet.core.types import PaddingValue, OffsetValue, ResponsiveNumber


class FlipDirection(str, Enum):
    HORIZONTAL = "horizontal"
    VERTICAL = "vertical"


class InitialSide(str, Enum):
    FRONT = "front"
    BACK = "back"


class FlipCard(ConstrainedControl):
    """
    Flet Flip Card kontrolü.

    Özellikler
    ----------
    flip_direction: FlipDirection = horizontal|vertical
    initial_side: InitialSide = front|back
    auto_flip_ms: Optional[int]  # Otomatik flip periyodu (ms). None/0 devre dışı.

    Çocuklar
    --------
    front: Control  # Ön yüz
    back: Control   # Arka yüz

    Metotlar
    --------
    flip(), show_front(), show_back()

    Not: Metotlar, Dart tarafında "action" ve "actionTs" üzerinden uygulanır.
    """

    def __init__(
        self,
        # Control
        visible: Optional[bool] = None,
        tooltip: Optional[str] = None,
        opacity: OptionalNumber = None,
        data: Any = None,
        left: OptionalNumber = None,
        top: OptionalNumber = None,
        right: OptionalNumber = None,
        bottom: OptionalNumber = None,
        width: OptionalNumber = None,
        height: OptionalNumber = None,
        padding: Optional[PaddingValue] = None,
        margin: Optional[PaddingValue] = None,
        scale: Optional[ResponsiveNumber] = None,
        rotate: Optional[float] = None,
        offset: Optional[OffsetValue] = None,
        animate_rotation: Optional[str] = None,
        animate_scale: Optional[str] = None,
        animate_offset: Optional[str] = None,
        animate_opacity: Optional[str] = None,
        # FlipCard spesifik
        flip_direction: Optional[FlipDirection] = FlipDirection.HORIZONTAL,
        initial_side: Optional[InitialSide] = InitialSide.FRONT,
        auto_flip_ms: Optional[int] = None,
        # Çocuklar
        front: Optional[ConstrainedControl] = None,
        back: Optional[ConstrainedControl] = None,
    ):
        super().__init__(
            visible=visible,
            tooltip=tooltip,
            opacity=opacity,
            data=data,
            left=left,
            top=top,
            right=right,
            bottom=bottom,
            width=width,
            height=height,
            padding=padding,
            margin=margin,
            scale=scale,
            rotate=rotate,
            offset=offset,
            animate_rotation=animate_rotation,
            animate_scale=animate_scale,
            animate_offset=animate_offset,
            animate_opacity=animate_opacity,
        )

        self.flip_direction = flip_direction
        self.initial_side = initial_side
        self.auto_flip_ms = auto_flip_ms

        self.__front = front
        self.__back = back

        # internal action timestamp to force rebuild/apply
        self.__action_ts = 0

    # region: control identity
    def _get_control_name(self):
        return "flip_card"
    # endregion

    # region: children mapping
    def _get_children(self):
        children = []
        if self.__front is not None:
            self.__front._set_attr_internal("n", "front")
            children.append(self.__front)
        if self.__back is not None:
            self.__back._set_attr_internal("n", "back")
            children.append(self.__back)
        return children

    @property
    def front(self):
        return self.__front

    @front.setter
    def front(self, value):
        self.__front = value
        self.update()

    @property
    def back(self):
        return self.__back

    @back.setter
    def back(self, value):
        self.__back = value
        self.update()
    # endregion

    # region: specific attrs
    @property
    def flip_direction(self) -> Optional[FlipDirection]:
        return self._get_attr("flipDirection")

    @flip_direction.setter
    def flip_direction(self, value: Optional[FlipDirection]):
        if value is None:
            self._set_attr("flipDirection", None)
        else:
            self._set_attr("flipDirection", value.value if isinstance(value, FlipDirection) else value)

    @property
    def initial_side(self) -> Optional[InitialSide]:
        return self._get_attr("initialSide")

    @initial_side.setter
    def initial_side(self, value: Optional[InitialSide]):
        if value is None:
            self._set_attr("initialSide", None)
        else:
            self._set_attr("initialSide", value.value if isinstance(value, InitialSide) else value)

    @property
    def auto_flip_ms(self) -> Optional[int]:
        return self._get_attr("autoFlipMs")

    @auto_flip_ms.setter
    def auto_flip_ms(self, value: Optional[int]):
        self._set_attr("autoFlipMs", value)
    # endregion

    # region: actions (methods)
    def _bump_ts(self):
        self.__action_ts += 1
        self._set_attr("actionTs", self.__action_ts)

    def flip(self):
        self._set_attr("action", "flip")
        self._bump_ts()
        self.update()

    def show_front(self):
        self._set_attr("action", "front")
        self._bump_ts()
        self.update()

    def show_back(self):
        self._set_attr("action", "back")
        self._bump_ts()
        self.update()
    # endregion