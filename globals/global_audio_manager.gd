extends Node

var music_audio_player_count: int = 2
var current_music_player: int = 0
var music_players: Array[AudioStreamPlayer] = []
var music_bus: String = "Music"

var music_fade_duration: float = 0.3


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in music_audio_player_count:
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.bus = music_bus
		audio_player.volume_db = -40
		music_players.append(audio_player)



func play_music(audio: AudioStream) -> void:
	if audio == music_players[current_music_player].stream:
		return
	
	var old_player = music_players[current_music_player]
	current_music_player = (current_music_player + 1) % music_audio_player_count
	
	var current_player = music_players[current_music_player]
	current_player.stream = audio
	play_and_fade_in(current_player)

	fade_out_and_stop(old_player)


func play_and_fade_in(player: AudioStreamPlayer) -> void:
	player.volume_db = -40
	player.play(0)
	var tween: Tween = create_tween()
	tween.tween_property(player, "volume_db", 0, music_fade_duration)


func fade_out_and_stop(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(player, "volume_db", -40, music_fade_duration)
	await tween.finished
	player.stop()

