# 🎴 Flet Flip Card Extension

A simple and lightweight **Flip Card** extension for [Flet](https://flet.dev), allowing you to create animated cards with **front** and **back** faces that flip smoothly.

![Demo](https://github.com/AyberkAtalay0/flet-flip-card/raw/main/examples/demo.gif)

---

## ✨ Features
- **Front & Back** card faces
- **Horizontal** and **Vertical** flip directions
- **Initial card side support** 
- **Custom flip duration**
- **Programmatic control**: flip, show_front, show_back
- **Flip event callback** (`on_flip_done`)

---

## ⚠️ Important Note
When running your app without building the extension using `flet build ...`,  
you will **only see an error box** instead of the actual flip card widget.  
To see the real widget, you must build the extension for your target platform.

---

## 📦 Installation

Install directly from GitHub:

```bash
pip install git+https://github.com/AyberkAtalay0/flet-flip-card.git
````

And add it to your **`pyproject.toml`**:

```toml
[project]
...
dependencies = [
  "flet==0.28.3",
  "flet-flip-card @ git+https://github.com/AyberkAtalay0/flet-flip-card",
  ...
]
```

---

## 🚀 Usage Example

```python
import flet as ft
from flet_flip_card import FlipCard, FlipCardDirection, FlipCardSide

def main(page: ft.Page):
    page.title = "FlipCard Example"
    page.padding = 20
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER
    page.vertical_alignment = ft.MainAxisAlignment.CENTER

    front = ft.Container(
        width=260,
        height=160,
        bgcolor=ft.Colors.BLUE_200,
        border_radius=12,
        alignment=ft.alignment.center,
        content=ft.Text("FRONT", size=28, weight=ft.FontWeight.BOLD),
    )

    back = ft.Container(
        width=260,
        height=160,
        bgcolor=ft.Colors.AMBER_200,
        border_radius=12,
        alignment=ft.alignment.center,
        content=ft.Text("BACK", size=28, weight=ft.FontWeight.BOLD),
    )

    status = ft.Text("Current side: BACK (initial)")

    def on_flip_done(e: ft.ControlEvent):
        side = e.data.upper()
        status.value = f"Current side: {side}"
        page.update()

    flip_card = FlipCard(
        front=front,
        back=back,
        duration=500,             
        direction=FlipCardDirection.VERTICAL, 
        initial_side=FlipCardSide.BACK,
        on_flip_done=on_flip_done,
    )

    btn_flip = ft.ElevatedButton(
        "Flip",
        on_click=lambda _: flip_card.flip()
    )

    page.add(
        ft.Column(
            [
                flip_card,
                ft.Row([btn_flip], alignment=ft.MainAxisAlignment.CENTER),
                status,
            ],
            spacing=16,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        )
    )

if __name__ == "__main__":
    ft.app(target=main)
```

---

## ⚙️ Project Structure

```
flet-flip-card/
├── src/
│   ├── flet_flip_card/         # Python API for Flet
│   └── flutter/flet_flip_card/ # Flutter implementation
├── examples/
│   └── flet_flip_card_example/ # Example usage
├── README.md
├── pyproject.toml
└── LICENSE
```

---

## 🛠 Development

If you want to contribute or test locally:

1. **Clone the repository**

   ```bash
   git clone https://github.com/AyberkAtalay0/flet-flip-card.git
   cd flet-flip-card
   ```

2. **Install dependencies**

   ```bash
   pip install "flet[all]" --upgrade
   pip install -e .
   ```

3. **Run the example**

   ```bash
   cd examples/flet_flip_card_example
   flet run
   ```

---

## 📌 Notes

* Built for **Flet 0.28.3**
* Works on **Web**, **Desktop**, and **Mobile**
* Simple API for quick prototyping
