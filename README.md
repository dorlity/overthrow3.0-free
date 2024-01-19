# overthrow4

## Create mklink folders
Create mklink folders in CMD. Just run ".\create_mklinks.bat". Solution only for windows OS
```cmd
set dota2_path=C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta
set custom_game_folder=overthrow4

mkdir "%dota2_path%\game\dota_addons\%custom_game_folder%"
mkdir "%dota2_path%\content\dota_addons\%custom_game_folder%"

mklink /j game "%dota2_path%\game\dota_addons\%custom_game_folder%"
mklink /j content "%dota2_path%\content\dota_addons\%custom_game_folder%"
```

## Как запустить у себя для внесения правок
- Запустить Dota 2 - Tools
- Создать новый проект "Create New Addon"
- По пути `{Пусть установки доты}/steamapps/common/dota 2 beta/` будет находиться две папки "content" и "game". Содержимое кастомки по отдельному из путей представлено в данном репозитории. Нужно создать до них mklink и появится возможность удаленно в них заходить
- При запуске в самих "Dota 2 - Tools" запустить свой проект
- Открыть Hammer
- Далее открыть mock карту из `content/maps/ot3_necropolis_ffa.vmap` у себя в проекте, куда вы прилинковали содержимое (File/Open)
- Открыть меню сборки "File/Build map..."
- В данном меню нажимать "Run (Skip Build)". НЕ надо Build, тк нет исходников карты, что с нуля ее собирать.
- Читаем/Меняем скрипты `content/panorama/` ИЛИ `game/scripts` и смотрим за результатом

## Добавлять обновления к проекту
- Загрузить https://valveresourceformat.github.io/
- Открываем с графическим интерфейсом софт
- Переходим через закладку "Explorer" к кастомке OVERTHROW 3.0 "Explorer/Dota 2/[Workshop ...] OVERTHROW 3.0 ...". Двойной клик
- Копируем все содержимое "Export as is" по пути кастомки в game
- А файлы из папок `"panorama/(layout|scripts|styles)"` по пути кастомки в content через "Decompile & export"

## Ветки
free - ветка с правками
main - оригинал от авторов

## Отличие от оригинала
Отличия от оригинала:
- Режим подписки повышен до "золотого" статуса
- Включен режим EpicEvent (в центре фиолетовые сферы)
- По бокам прилетает cиняя сфера
- Предметы в магазине (косметика доступна)
- Добавлен сапог Сено
- Увеличено время игры 20 -> 25 минут
- Увеличен минимальный порог смертей 30 -> 55
- Увеличена скорость прогресса пассивного получения белых сфер
- Цена сфер common(1500), rare(3500), epic(4000)
- В начале игры выдается 1000 валюты
- Изменены цены в "misc" категории для epic(500) и rare(250) сферы
- Базовое количество rerolls 8 -> 200
- Сжатые видео panorama (ffmpeg -i NAME.webm -c:v vp9 -r:v 24 NAMEZ.webm)