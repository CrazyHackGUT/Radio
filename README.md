# Radio

**Текущая версия**: _1.3_

**Лицензия**: _[GNU GPL 3.0](https://github.com/CrazyHackGUT/Radio/blob/master/LICENSE)_

**Установка (плагин)**:

- Скачать из [раздела релизов](http://git.kruzefag.ru/Kruzya/Radio/releases) последнюю версию
- Распаковать архив
- Открыть конфиг, добавить свои радио-станции, по желанию изменить ссылку на вспомогательный "скрипт"
- Скопировать все файлы, кроме **web_script.html** на сервер
- Перезапустить сервер **ИЛИ** сменить карту **ИЛИ** выполнить в консоли сервера команду `sm plugins load Radio`

**Установка (веб-скрипт) (необязательно)**:

- Скачать из [раздела релизов](http://git.kruzefag.ru/Kruzya/Radio/releases) последнюю версию
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
  - /addons/sourcemod/configs/Radio.cfg
  - /addons/sourcemod/plugins/Radio.smx
  - /addons/sourcemod/scripting/Radio.sp
  - /addons/sourcemod/translatons/Radio.phrases.txt
- Перезапустить сервер **ИЛИ** сменить карту **ИЛИ** выполнить в консоли сервера команду `sm plugins unload Radio`
