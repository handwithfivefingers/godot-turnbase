extends Resource
class_name SkillPreset

@export var skillName: String = ""
@export var skillDesc: String = ""
@export var skillDmg: int = 0
@export var skillCost: int = 0
@export var skillType: String = "attack"

# Dùng khi muốn khởi tạo từ dictionary trong code
static func from_dict(data: Dictionary) -> SkillPreset:
	var s := SkillPreset.new()
	s.skillName = data.get("skillName", "")
	s.skillDesc = data.get("skillDesc", "")
	s.skillDmg = data.get("skillDmg", 0)
	s.skillCost = data.get("skillCost", 0)
	s.skillType = data.get("skillType", "attack")
	return s
