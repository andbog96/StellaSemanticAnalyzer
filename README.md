# Stella Semantic Analyzer

Семантический анализатор программ на языке Stella. Проект оформлен как исполняемый пакет Swift Package Manager (SwiftPM): исходный текст программы передаётся анализатору через стандартный ввод.

## Системные требования

- macOS 15 или новее;
- Swift 6.0 или новее;
- Xcode 16 или новее либо отдельный Swift toolchain 6.0+;

Проверьте установленную версию Swift:

```sh
swift --version
```

Если установлено несколько версий Xcode, выберите нужную в **Xcode → Settings → Locations → Command Line Tools**. То же самое можно сделать в терминале:

```sh
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

## Сборка из терминала

```sh
swift package resolve
swift build
```

Анализатор читает программу Stella из стандартного ввода. Запустить его без обращения к пути в `.build` можно так:

```sh
swift run StellaSemanticAnalyzer < path/to/program.stella
```

При успешном анализе программа завершается без вывода. Ошибки разбора или семантического анализа выводятся в терминал.
