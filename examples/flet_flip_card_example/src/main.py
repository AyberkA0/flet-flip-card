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
        status.value = f"Current side: {e.data.upper()}"
        page.update()

    flip_card = FlipCard(
        front=front,
        back=back,
        duration=500,
        direction=FlipCardDirection.VERTICAL,
        initial_side=FlipCardSide.BACK,
        on_flip_done=on_flip_done,
    )

    async def on_flip_click(e):
        await flip_card.toggle()

    btn_flip = ft.ElevatedButton("Flip", on_click=on_flip_click)

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


ft.app(target=main)
