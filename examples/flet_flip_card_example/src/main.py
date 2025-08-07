import flet as ft

from flet_flip_card import FletFlipCard


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    page.add(

                ft.Container(height=150, width=300, alignment = ft.alignment.center, bgcolor=ft.Colors.PURPLE_200, content=FletFlipCard(
                    tooltip="My new FletFlipCard Control tooltip",
                    value = "My new FletFlipCard Flet Control", 
                ),),

    )


ft.app(main)
