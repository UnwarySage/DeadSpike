extends CanvasLayer

var stage :Stage =null

onready var water_bar:TextureProgress = find_node("WaterBar",true)
onready var health_bar:TextureProgress = find_node("HealthBar",true)
onready var spell_icons:AnimatedSprite = find_node("SpellIcons",true)


func _ready():
	stage.player.connect("on_water_adjust", self, "adjust_water_level")
	water_bar.max_value = stage.player.max_water
	water_bar.value = stage.player._present_water
	
	stage.player.connect("on_health_adjust", self, "adjust_health_level")
	health_bar.max_value = stage.player.max_health
	health_bar.value = stage.player._present_health
	
	stage.player.connect("on_spell_change", self, "change_spell_icon")
	print("HUD: Loaded")


func adjust_water_level(inp_level):
	water_bar.value = inp_level
	
func adjust_health_level(inp_level):
	health_bar.value = inp_level

func change_spell_icon(inp_spell):
	spell_icons.frame = inp_spell