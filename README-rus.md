# YouType для macOS
### Может отображать текущую раскладку клавиатуры в строке состояния в виде флагов в macOS 12.4
![Screenshot1.png](Screenshot1.png)
[**Поддержать**](https://www.buymeacoffee.com/freefelt)  |  [**Обратная связь**](https://github.com/freefelt/YouType/issues/new)  |  [Обзоры / упоминания](reviews.md)  |  [Скачать](https://github.com/freefelt/YouType/raw/main/YouType.zip) |  [YouType for Windows](Windows/README-rus.md)  |  This page is also available in: [english](../..)

**YouType** это полезная программа, которая позволит тебе сохранить нервы и работать на компьютере более эффективно. При наведении курсора мыши на любое текстовое поле, YouType показывает рядом с указателем флажок текущей раскладки клавиатуры. Ты будешь видеть текущий язык как раз перед вводом текста, и в том месте экрана, куда ты смотришь в данный момент. Это очень удобно! Это позволит тебе делать меньше ошибок ввода и не терять время на исправление уже напечатанного.

Также YouType будет удобна при работе в **полноэкранном режиме**, когда индикатор текущей раскладки скрывается вместе с главной панелью. Флажок возле курсора в нужном месте подскажет какой сейчас выбран язык ввода.

# Установка / Удаление

## С помощью [Homebrew](https://github.com/Homebrew/homebrew-cask)
Для установки YouType откройте Terminal.app и выполните команду:
```bash
brew install youtype --no-quarantine
```
`--no-quarantine` - параметр помогает избежать всплывающего окна Gatekeeper при первом запуске.

Для удаления:
```bash
brew uninstall youtype --zap
```
`--zap` - параметр удаляет настройки и кэш приложения.

## С помощью [скриптов](https://github.com/freefelt/YouType/raw/main/Scripts)
Для установки YouType откройте Terminal.app и выполните команду:
```bash
/bin/bash -c "$(curl -fsSL https://github.com/freefelt/YouType/raw/main/Scripts/Installer.sh)"
```
Для удаления:
```bash
/bin/bash -c "$(curl -fsSL https://github.com/freefelt/YouType/raw/main/Scripts/Uninstaller.sh)"
```
Если нужно запустить скрипты неинтерактивно, можно добавить параметр `NONINTERACTIVE=1` перед командами:
```bash
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL http...
```
