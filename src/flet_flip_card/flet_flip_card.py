from __future__ import annotations

from typing import List, Optional

from flet.core.constrained_control import ConstrainedControl
from flet.core.control import Control


class FlipCard(ConstrainedControl):
    """
    Minimal Flet FlipCard (Flet 0.28.3 uyumlu).
    Sadece front/back çocuklarını alır ve flip/show_front/show_back metodlarını destekler.
    """

    def __init__(
        self,
        front: Optional[Control] = None,
        back: Optional[Control] = None,
    ):
        super().__init__()
        self.front = front
        self.back = back

    # Kontrol adı Dart tarafındaki `args.control.type` ile birebir aynı olmalı.
    def _get_control_name(self) -> str:
        return "flet_flip_card"

    # Çocukları isimlendirerek bildir.
    def _get_children(self) -> List[Control]:
        children: List[Control] = []
        if self.front:
            self.front._set_attr_internal("n", "front")
            children.append(self.front)
        if self.back:
            self.back._set_attr_internal("n", "back")
            children.append(self.back)
        return children

    # Python -> Dart method çağrıları (doc'taki pattern)
    def flip(self):
        self.invoke_method("flip")

    def show_front(self):
        self.invoke_method("show_front")

    def show_back(self):
        self.invoke_method("show_back")
