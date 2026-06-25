class_name BulletinConfig

enum Keys{
	PauseMenu,
	SettingsMenu,
	Inventory,
	InteractionPrompt,
	SellMenu,
	WinScreen,
	SkillTree,
	SkillTreeToolTip,
	BossHpBar,
	PlaceholderDayEnd,
}


static func get_bulletin(bulletin_key:Keys) -> Node:
	return load(BULLETIN_PATHS[bulletin_key]).instantiate()


const BULLETIN_PATHS := {
	Keys.PauseMenu : "res://UI/pause_screen.tscn",
	Keys.SettingsMenu : "res://UI/settings_menu.tscn",
	Keys.Inventory: "res://Bulletins/player_menus/player_menu_base.tscn",
	Keys.InteractionPrompt: "res://Bulletins/interaction_prompt/interaction_prompt.tscn",
	Keys.SellMenu: "res://Bulletins/player_menus/player_menu_with_sell_area.tscn",
	Keys.WinScreen: "res://UI/win_screen/win_screen.tscn",
	Keys.SkillTree: "res://UI/skill_tree/skill_tree.tscn",
	Keys.SkillTreeToolTip: "res://UI/skill_tree/tooltip/skill_tree_tool_tip.tscn",
	Keys.BossHpBar: "res://Bulletins/boss_health_bar/boss_health_bar.tscn",
	Keys.PlaceholderDayEnd: "res://UI/placeholders/day_end/placeholder_day_end.tscn"
}
