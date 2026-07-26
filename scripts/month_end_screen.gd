extends Label

const MAIN_TEXT_TEMPLATE := '%s пройден!\nВаша ЗП [font otv="wght=500"][color="#%s"]%s$[/color][/font]!'
const SALARY_TEXT_TEMPLATE := '$%d'
@export var dollars_for_trust_unit := 75
@export var main_text_label: RichTextLabel
@export var salary_text_label: RichTextLabel
@export var salary_increased_color: Color
@export var salary_decreased_color: Color
@export var same_salary_color: Color
@export var button: Button

func _ready() -> void:
	var salary := evaluate_salary()
	UserData.change_balance(salary)
	var salary_changed := salary != UserData.prev_month_salary
	var salary_increased := salary > UserData.prev_month_salary
	
	main_text_label.text = MAIN_TEXT_TEMPLATE % [
		UserData.cur_date.to_month_string(),
		((salary_increased_color if salary_increased
		else salary_decreased_color if salary_changed
		else same_salary_color).to_html()),
		(("выросла на " if salary_increased else "снизилась на ") + 
		str(abs(salary - UserData.prev_month_salary))) if salary_changed
		else "не поменялась."
	]
	
	UserData.prev_month_salary = salary
	UserData.add_days()
	SaveManager.save_game()
	button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainScreen.tscn"))

func evaluate_salary() -> int:
	return dollars_for_trust_unit * UserData.current_trust
