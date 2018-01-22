# Radio

**Текущая версия**: _1.3.2.1_

**Лицензия**: _[GNU GPL 3.0](https://github.com/CrazyHackGUT/Radio/blob/master/LICENSE)_

**Установка (плагин)**:

- Скачать из [раздела релизов](https://github.com/CrazyHackGUT/Radio/releases) последнюю версию
- Распаковать архив
- Скопировать все файлы, кроме **web_script.html** на сервер
- Перезапустить сервер **ИЛИ** сменить карту **ИЛИ** выполнить в консоли сервера команду `sm plugins load Radio`
- Открыть конфиг, добавить свои радио-станции, по желанию изменить ссылку на вспомогательный "скрипт"

**Установка (веб-скрипт) (необязательно)**:

- Скачать из [раздела релизов](https://github.com/CrazyHackGUT/Radio/releases) последнюю версию
- Распаковать архив
- Скопировать **web_script.php**, **player.swf** на веб-сервер, указать в конфиге плагина ссылку на него.
- Перезапустить сервер **ИЛИ** сменить карту **ИЛИ** выполнить в консоли сервера команду `sm plugins reload Radio`

**Удаление (веб-скрипт)**:

- Удалить файлы:
  - web_script.php
  - player.swf
- Вернуть старую ссылку (*http://kruzya.beget.tech/stuff/Radio_v2/*) в конфиге.
- Перезапустить сервер **ИЛИ** сменить карту **ИЛИ** выполнить в консоли сервера команду `sm plugins reload Radio`

**Удаление (плагин)**:

- Удалить файлы:
  - /cfg/sourcemod/radio.cfg
  - /addons/sourcemod/data/Radio.cfg
  - /addons/sourcemod/plugins/Radio.smx
  - /addons/sourcemod/scripting/Radio.sp
  - /addons/sourcemod/translatons/Radio.phrases.txt
- Перезапустить сервер **ИЛИ** сменить карту **ИЛИ** выполнить в консоли сервера команду `sm plugins unload Radio`
