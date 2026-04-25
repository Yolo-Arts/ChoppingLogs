class_name BulletinConfig

enum Keys{
	PauseMenu,
	SettingsMenu,
	Inventory,
	InteractionPrompt,
	SellMenu,
}


static func get_bulletin(bulletin_key:Keys) -> Node:
	return load(BULLETIN_PATHS[bulletin_key]).instantiate()


const BULLETIN_PATHS := {
	Keys.PauseMenu : "res://UI/pause_screen.tscn",
	Keys.SettingsMenu : "res://UI/settings_menu.tscn",
	Keys.Inventory: "res://Bulletins/player_menus/player_menu_base.tscn",
	Keys.InteractionPrompt: "res://Bulletins/interaction_prompt/interaction_prompt.tscn",
	Keys.SellMenu: "res://Bulletins/player_menus/player_menu_with_sell_area.tscn"
}
