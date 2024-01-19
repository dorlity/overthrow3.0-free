set dota2_path=C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta
set custom_game_folder=overthrow4

mkdir "%dota2_path%\game\dota_addons\%custom_game_folder%"
mkdir "%dota2_path%\content\dota_addons\%custom_game_folder%"

mklink /j game "%dota2_path%\game\dota_addons\%custom_game_folder%"
mklink /j content "%dota2_path%\content\dota_addons\%custom_game_folder%"