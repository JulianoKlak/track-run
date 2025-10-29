# 📱 Guia para Gerar o APK do Track Run

## ✅ Alterações Realizadas

1. **Ícone do Aplicativo Atualizado** 🎨
   - Novo ícone criativo com tema de corrida e conquista territorial
   - Design com hexágonos (representando os territórios)
   - Figura de corredor em movimento
   - Hexágonos conquistados ao redor (em verde)
   - Gerado em todas as resoluções necessárias (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)

2. **Permissões Configuradas** 🔐
   - Permissões de localização (GPS) adicionadas ao AndroidManifest.xml
   - Permissão de internet para carregar os mapas
   - Permissão de localização em segundo plano
   - Foreground service para rastreamento contínuo

3. **Nome do Aplicativo Atualizado** 📝
   - Nome alterado de "track_run" para "Track Run"
   - Application ID atualizado: `br.com.trackrun.app`
   - Package name atualizado

## 🛠️ Como Gerar o APK

### Opção 1: Gerar APK de Debug (mais rápido)

```bash
flutter build apk --debug
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-debug.apk`

### Opção 2: Gerar APK de Release (recomendado para testes)

```bash
flutter build apk --release
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

### Opção 3: Gerar APK Split por Arquitetura (menor tamanho)

```bash
flutter build apk --split-per-abi
```

Isso gerará múltiplos APKs otimizados:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM - recomendado para dispositivos modernos)
- `app-x86_64-release.apk` (Emuladores)

### Opção 4: Gerar App Bundle (para Google Play Store)

```bash
flutter build appbundle --release
```

O bundle será gerado em: `build/app/outputs/bundle/release/app-release.aab`

## 📲 Como Instalar no Dispositivo

### Via USB (ADB)

1. Ative a depuração USB no seu dispositivo Android
2. Conecte o dispositivo ao computador
3. Execute:

```bash
flutter install
```

Ou manualmente:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Via Transferência de Arquivo

1. Copie o arquivo APK para o seu dispositivo
2. No dispositivo, navegue até o arquivo APK
3. Toque no arquivo para instalar
4. Permita instalação de fontes desconhecidas se solicitado

## ⚙️ Requisitos do Sistema

- **Flutter SDK**: >= 3.22.0
- **Dart SDK**: >= 3.8.0
- **Android minSdk**: 21 (Android 5.0 Lollipop)
- **Android targetSdk**: Latest (configurado automaticamente)

## 🎯 Versão Atual

- **Version Name**: 1.0.0
- **Version Code**: 1

## 🔍 Verificar Pré-requisitos

Antes de compilar, execute:

```bash
flutter doctor -v
```

Certifique-se de que todas as dependências estão instaladas:

```bash
flutter pub get
```

## 🐛 Solução de Problemas

### Erro de licenças Android

```bash
flutter doctor --android-licenses
```

### Erro de build

```bash
flutter clean
flutter pub get
flutter build apk
```

### Verificar dispositivos conectados

```bash
flutter devices
```

## 📝 Notas Importantes

1. **Primeira Instalação**: Na primeira vez que instalar o APK, será necessário conceder permissões de localização
2. **Localização em Segundo Plano**: Para Android 10+, você precisará conceder permissão de localização "o tempo todo"
3. **Bateria**: O rastreamento contínuo pode consumir bateria - recomenda-se parar o rastreamento quando não estiver em uso
4. **Dados Móveis**: O aplicativo requer internet para carregar os mapas do OpenStreetMap

## 🎉 Aproveite o Track Run!

Após instalar, você poderá:
- ✅ Criar sua conta com nome de usuário único
- ✅ Começar a rastrear suas corridas/caminhadas
- ✅ Conquistar territórios hexagonais no mapa
- ✅ Ver seu histórico de trajetos
- ✅ Visualizar territórios conquistados por todos os usuários

---

**Desenvolvido por**: Juliano Klak
**Licença**: MIT
