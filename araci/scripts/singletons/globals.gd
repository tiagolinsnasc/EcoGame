extends Node

var coins := 0
var score := 0
var player_life := 3

#Flags que auxiliam na exibição das primeira informações sobre os ítens coletados
var flag_grab_one_life = false
var flag_grab_one_evidence = false
var flag_grab_one_checkpoint = false
var flag_grab_one_information = false
var flag_grab_one_animal_in_trap = false

#Criados para permitir o mecanismo de checkpoint:
var araci = null #Carregado em world.gd
var current_checkpoint = null
var araci_start_position = null #Carregado em world.gd

func respaw_player():
	if current_checkpoint != null:
		araci.global_position = current_checkpoint.global_position
	else:
		araci.global_position = araci_start_position


func hyphenate_ptbr(word: String) -> Array:
	var vowels = ["a","e","i","o","u","á","é","í","ó","ú"]
	var digraphs = ["nh","lh","ch"]
	var syllables = []
	var i = 0
	
	while i < word.length():
		var syl = word[i]
		
		# Verifica dígrafos
		if i < word.length() - 1 and word.substr(i, 2).to_lower() in digraphs:
			syl = word.substr(i, 2)
			i += 2
		else:
			i += 1
		
		# Junta vogais seguintes
		while i < word.length() and word[i].to_lower() in vowels:
			syl += word[i]
			i += 1
		
		syllables.append(syl)
	
	return syllables


func hyphenate_text_ptbr(text: String, max_width: int, label: Label) -> String:
	var result: String = ""
	var current_line: String = ""
	var test_word: String = ""
		
	for word in text.split(" "):
		var test_line: String = current_line + ("" if current_line == "" else " ") + word
		var width := label.get_theme_font("font").get_string_size(test_line).x
		
		if width > max_width:
			# Tenta dividir a palavra em sílabas
			var syllables = hyphenate_ptbr(word)
			var partial: String = ""
			
			for syl in syllables:
				test_word = partial + syl
				var w := label.get_theme_font("font").get_string_size(current_line + " " + test_word).x
				
				if w > max_width:
					result += current_line + "-\n"
					current_line = syl
				else:
					partial = test_word
			
			current_line += " " + partial
		else:
			current_line = test_line
	
	result += current_line
	return result
