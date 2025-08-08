# 🎴 Flet Flip Card Extension

A simple and lightweight **Flip Card** extension for [Flet](https://flet.dev), allowing you to create animated cards with **front** and **back** faces that flip smoothly.

![Demo](https://github.com/AyberkAtalay0/flet-flip-card/raw/main/examples/demo.gif)

---

## 📦 Installation

Install directly from GitHub:

```bash
pip install git+https://github.com/AyberkAtalay0/flet-flip-card.git
````

Or add it to your **`pyproject.toml`**:

```toml
[tool.poetry.dependencies]
python = "^3.9"
flet = ">=0.28.3"
flet-flip-card = { git = "https://github.com/AyberkAtalay0/flet-flip-card.git" }
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
        )
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
* Minimal parameters — only `front` and `back` controls are required
* Works on **Web**, **Desktop**, and **Mobile**
* Simple API for quick prototyping