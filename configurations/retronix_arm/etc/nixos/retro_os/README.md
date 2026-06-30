# RetroOS

Frontend do sistema operacional retro baseado em Flutter, projetado para rodar em dispositivos ARM com NixOS. Fornece uma interface navegável por gamepad para seleção e abertura de jogos via RetroArch.

## Funcionalidades

- Seleção de consoles e jogos navegável por gamepad ou teclado
- Suporte a Nintendo 64 via core `mupen64plus` no RetroArch
- Configurações gráficas por console (resolução, MSAA, filtro de textura, frame duplication)
- Menu de configurações acessível pelo botão Start
- Tela de desligamento do sistema

## Controles

| Botão (gamepad) | Teclado | Ação |
|-----------------|---------|------|
| D-Pad / Analógico | Setas | Navegar |
| A | Enter | Confirmar |
| B | Escape / Backspace | Voltar |
| Start | F1 | Abrir configurações |

## Estrutura de arquivos

Os arquivos de consoles e jogos ficam em:

**Linux/NixOS:**
```
~/.local/share/retro_os/Consoles/
└── Nintendo 64/
    ├── console_image.png
    └── Games/
        └── <Nome do Jogo>/
            ├── game_image.png
            └── Game/
                └── rom.z64
```

**Windows:**
```
%APPDATA%\retro_os\Consoles\
```

## Configurações

Salvas em `~/.local/share/retro_os/settings.json`. As configurações gráficas do N64 são aplicadas em `~/.config/retroarch/config/Mupen64Plus-Next/Mupen64Plus-Next.opt` antes de cada jogo iniciar.

## Build (NixOS)

```bash
nixos-rebuild switch
```

O app é compilado automaticamente via `retro-os.nix` usando `buildFlutterApplication`. O `pubspec.lock.json` deve estar sincronizado com `pubspec.lock`:

```bash
flutter pub get
dart run tool/lock_to_json.dart
```

## Dependências

| Pacote | Uso |
|--------|-----|
| `gamepads` | Leitura de eventos do gamepad |
| `flutter_svg` | Renderização da logo SVG |
