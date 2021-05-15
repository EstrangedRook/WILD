extends Node

const SUMMER_SOLSTICE_MONTH = 6
const SUMMER_SOLSTICE_DAY = 21
const WINTER_SOLSTICE_MONTH = 12
const WINTER_SOLSTICE_DAY = 21

const MONTH_DAYS = [31,28,31,30,31,30,31,31,30,31,30,31]

export(float) var sun_arc = 400
export(float) var sun_offset = 300
export(float) var sun_center_height = 300

export(float) var moon_center_height = 170

export(float) var NIGHT_TIME = -0.1
export(float) var DAWN_TIME = -0.05
export(float) var MORNING_TIME = 0.2
export(float) var MIDDAY_TIME = 0.5

export(Color, RGBA) var SKY_MIDDAY_COLOR
export(Color, RGBA) var SKY_MORNING_COLOR
export(Color, RGBA) var SKY_DAWN_COLOR
export(Color, RGBA) var SKY_NIGHT_COLOR

export(Color, RGBA) var CLOUD_MIDDAY_COLOR
export(Color, RGBA) var CLOUD_MORNING_COLOR
export(Color, RGBA) var CLOUD_DAWN_COLOR
export(Color, RGBA) var CLOUD_NIGHT_COLOR

export(Color, RGBA) var MIDDAY_COLOR
export(Color, RGBA) var MORNING_COLOR
export(Color, RGBA) var DAWN_COLOR
export(Color, RGBA) var NIGHT_COLOR

var time_holder = 0

func _ready():
	pass

func _process(delta):
	var date = OS.get_datetime()
	var days_from_ss = _determine_number_of_days_elapsed_summer_solstice(date.year, date.month, date.day)
	var time_in_seconds = date.hour * 3600 + date.minute * 60 + date.second
	time_holder += 120
	if time_holder > 86400.0:
		time_holder = 0
	time_in_seconds = time_holder
	time_in_seconds /= 86400.0
	
	var days_to_summer_solstice = _determine_number_of_days_elapsed_summer_solstice(date.year, date.month, date.day)
	var sun_position = _determine_sun_position_func(time_in_seconds, days_to_summer_solstice)
	_set_color_values(sun_position)
	
	_moon_and_sun_position(sun_position, time_in_seconds, days_to_summer_solstice)

	
func _moon_and_sun_position(sun_height, time_in_seconds, days_to_summer_solstice):
	var sun_position = Vector2(sun_arc, 0)
	sun_position = sun_position.rotated(deg2rad(range_lerp(time_in_seconds, 0, 1, -180, -1)))
	sun_position.y += sun_center_height
	sun_position.y += range_lerp(sun_height, -1, 1, sun_offset*0.25,-sun_offset)
	$ParallaxBackground/Celestial_Layer/Sun.position = sun_position
	
	var moon_position = Vector2(sun_arc, 0)
	if time_in_seconds <= 0.5:
		moon_position = moon_position.rotated(deg2rad(range_lerp(time_in_seconds, 0, 1, -90, 90)))
	else:
		moon_position = moon_position.rotated(deg2rad(range_lerp(time_in_seconds, 0, 1, -270, -90)))
	moon_position.y += moon_center_height
	$ParallaxBackground/Celestial_Layer/Moon.position = moon_position
	
	var moon_phase = _get_moon_phase()
	$ParallaxBackground/Celestial_Layer/Moon/Moon_Main.frame = moon_phase
	$ParallaxBackground/Celestial_Layer/Moon/Moon_Shadow.frame = moon_phase

func _get_moon_phase():
	var day = (OS.get_unix_time() - (86400/2)) / 86400
	var moon_phase = day % 8
	return moon_phase

func _determine_sun_position_func(time_in_seconds, days_to_summer_solstice):
	return _determine_sun_position(time_in_seconds * (2*PI), deg2rad(53.3), deg2rad(_effective_axial_tilt(days_to_summer_solstice)))

func _determine_sun_position(earth_angle, latitude, tilt):
	var holder = sin(latitude)*sin(tilt)-cos(earth_angle)*cos(latitude)*cos(tilt)
	return holder

func _effective_axial_tilt(t):
	var holder = (2*PI) * t
	holder /= 365
	holder = cos(holder)
	holder *= 23.5
	return holder

func _set_color_values(sun_position):
	var current_color
	var current_sky_color
	var current_cloud_color
	var current_percent : float = 0
	if sun_position > MIDDAY_TIME:
		current_color = MIDDAY_COLOR
		current_sky_color = SKY_MIDDAY_COLOR
		current_cloud_color = CLOUD_MIDDAY_COLOR
	elif sun_position > MORNING_TIME:
		current_percent = _calculate_percent(sun_position - MORNING_TIME, MORNING_TIME, MIDDAY_TIME)
		current_color = _combine_colors(MIDDAY_COLOR, MORNING_COLOR, current_percent)
		current_sky_color = _combine_colors(SKY_MIDDAY_COLOR, SKY_MORNING_COLOR, current_percent)
		current_cloud_color = _combine_colors(CLOUD_MIDDAY_COLOR, CLOUD_MORNING_COLOR, current_percent)
	elif sun_position > DAWN_TIME:
		current_percent = _calculate_percent(sun_position - DAWN_TIME, DAWN_TIME, MORNING_TIME)
		current_color = _combine_colors(MORNING_COLOR, DAWN_COLOR, current_percent)
		current_sky_color = _combine_colors(SKY_MORNING_COLOR, SKY_DAWN_COLOR, current_percent)
		current_cloud_color = _combine_colors(CLOUD_MORNING_COLOR, CLOUD_DAWN_COLOR, current_percent)
	elif sun_position > NIGHT_TIME:
		current_percent = _calculate_percent(sun_position - NIGHT_TIME, DAWN_TIME, NIGHT_TIME)
		current_color = _combine_colors(DAWN_COLOR, NIGHT_COLOR, current_percent)
		current_sky_color = _combine_colors(SKY_DAWN_COLOR, SKY_NIGHT_COLOR, current_percent)
		current_cloud_color = _combine_colors(CLOUD_DAWN_COLOR, CLOUD_NIGHT_COLOR, current_percent)
	else:
		current_color = NIGHT_COLOR
		current_sky_color = SKY_NIGHT_COLOR
		current_cloud_color = CLOUD_NIGHT_COLOR
	$Day_Night_Modulator.color = current_color
	$ParallaxBackground/Cloud_Layer/Clouds.modulate = current_cloud_color
	$ParallaxBackground/Sky/Sky.modulate = current_sky_color
	$ParallaxBackground/Celestial_Layer/Moon/Moon_Shadow.get_material().set_shader_param("color", current_sky_color)
	var night_fade = clamp((-sun_position) * 5,0,1)
	$ParallaxBackground/Star_Layer.modulate.a = night_fade
	$ParallaxBackground/Celestial_Layer/Moon/Moon_Main.modulate.a = night_fade

func _combine_colors(colorA, colorB, percentA):
	var colorTemp = Color(0,0,0,0)
	var percentB = 1 - percentA
	colorTemp.r = (colorA.r * percentA) + (colorB.r * percentB)
	colorTemp.g = (colorA.g * percentA) + (colorB.g * percentB)
	colorTemp.b = (colorA.b * percentA) + (colorB.b * percentB)
	colorTemp.a = (colorA.a * percentA) + (colorB.a * percentB)
	return colorTemp

func _determine_number_of_days_elapsed(year, month, day):
	var days = 0
	for i in range(1,month):
		days += MONTH_DAYS[i-1]
	if month > 2 && _determine_leap_year(year):
		days += 1
	days += day
	return days

func _determine_number_of_days_elapsed_summer_solstice(year, month, day):
	var days = _determine_number_of_days_elapsed(year, month, day)
	var solstice_day = _determine_number_of_days_elapsed(year, SUMMER_SOLSTICE_MONTH, SUMMER_SOLSTICE_DAY)
	days -= solstice_day
	return days

func _determine_leap_year(year):
	var leap_year = false
	if year % 4 == 0:
		if year % 100 == 0:
			if year % 400 == 0:
				leap_year = true
		else:
			leap_year = true
	return leap_year
	
func _calculate_percent(value, A, B):
	var difference : float = abs(A - B);
	var percent : float = float(value) / difference;
	return percent
