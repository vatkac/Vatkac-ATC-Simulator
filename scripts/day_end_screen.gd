extends CanvasLayer

const MAIN_TEXT_STANDARD_TEMPLATE := '%s пройден!\nВаше доверие [font otv="wght=500"][color="#%s"]%s[/color][/font]!'
const MAIN_TEXT_FIRED_TEMPLATE := "Ваше доверие упало до нуля. Вы были уволены из аэропорта. Весь ваш прогресс утерян. Вы можете начать игру заново."
const TRUST_TEXT_TEMPLATE := '[color="#%s"]%d[/color]/100'
const STANDARD_HEADER = "ДЕНЬ\nПРОЙДЕН!"
const FIRED_HEADER = "ВЫ\nУВОЛЕНЫ."
const STANDARD_BUTTON_TEXT = "Продолжить"
const FIRED_BUTTON_TEXT = "Начать карьеру заново"

@export var header_label: Label
@export var main_text_label: RichTextLabel
@export var trust_text_label: RichTextLabel
@export var button: Button
@export var unjustified_decline_penalty := 3
@export var disaster_penalty := 20
@export var overflow_penalty := 5
@export var ignored_clearance_penalty := 4
@export var trust_increased_color: Color
@export var trust_decreased_color: Color

func _ready() -> void:
	var trust_change := -_evaluate_trust_penalty()
	if trust_change == 0:
		trust_change = 2
	UserData.change_trust(trust_change)
	
	var fired := UserData.current_trust == 0
	var increased := trust_change > 0
	var color := trust_increased_color.to_html() if increased else trust_decreased_color.to_html()
	
	main_text_label.text = (MAIN_TEXT_STANDARD_TEMPLATE % [
		UserData.cur_date.to_formatted_string("%02d.%02d.%04d"),
		color,
		"выросло" if increased else "упало"
	]) if not fired else MAIN_TEXT_FIRED_TEMPLATE
	header_label.text = STANDARD_HEADER if not fired else FIRED_HEADER
	header_label.add_theme_color_override("font_color", trust_increased_color if not fired else trust_decreased_color)
	trust_text_label.text = TRUST_TEXT_TEMPLATE % [color, UserData.current_trust]
	
	if fired:
		SaveManager.remove_save_file()
		UserData.reset_all()
		button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Boot.tscn"))
		return
	
	var date_before := UserData.cur_date
	UserData.reset_day()
	UserData.add_days()
	if date_before.month == UserData.cur_date.month:
		SaveManager.save_game()
		button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainScreen.tscn"))
	else:
		UserData.cur_date = date_before
		button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MonthEndScreen.tscn"))

func _evaluate_trust_penalty() -> int:
	var unjustified_declines_penalty := unjustified_decline_penalty * UserData.unjustified_declines_count
	var disaster_final_penalty := disaster_penalty if UserData.disaster else 0
	var overflows_penalty := overflow_penalty * UserData.table_overflows
	var ignored_clearances_penalty := ignored_clearance_penalty * UserData.ignored_clearances_count
	return unjustified_declines_penalty + disaster_final_penalty + overflows_penalty + ignored_clearances_penalty
