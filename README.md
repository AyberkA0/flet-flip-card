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
you will **only see a placeholder** instead of the actual flip card widget.  
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
from flet_flip_card import FletFlipCard

def main(page: ft.Page):
    page.title = "Flet Flip Card Example"
    page.vertical_alignment = "center"
    page.horizontal_alignment = "center"

    flip_card = FletFlipCard(
        front=ft.Container(
            width=200,
            height=200,
            bgcolor=ft.Colors.BLUE,
            alignment=ft.alignment.center,
            content=ft.Text("Front", color=ft.Colors.WHITE, size=24)
        ),
        back=ft.Container(
            width=200,
            height=200,
            bgcolor=ft.Colors.RED,
            alignment=ft.alignment.center,
            content=ft.Text("Back", color=ft.Colors.WHITE, size=24)
        ),
        duration=500
    )

    page.add(flip_card)

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