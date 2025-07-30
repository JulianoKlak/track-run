# 🏃 Track Run — Corrida Territorial com Flutter + OpenStreetMap

Aplicativo em desenvolvimento inspirado em jogos como *Run An Empire*, com foco em conquistar território ao correr por regiões no mapa. Criado especialmente para o Brasil, usando tecnologias open-source.

---

## 🚀 Tecnologias Utilizadas

- **Flutter** — Framework para desenvolvimento mobile/web/desktop
- **flutter_map** — Pacote Flutter baseado em Leaflet, usa OpenStreetMap
- **geolocator** — Para obter localização do dispositivo
- **permission_handler** — Permissões de localização
- **h3_flutter** — Para divisão do mapa em hexágonos com a biblioteca H3 (Uber)

---

## 📦 Estrutura inicial

- Projeto criado com `flutter create track_run`
- Pacotes adicionados via `flutter pub add`
- Uso de OpenStreetMap via `flutter_map` (não exige cartão de crédito!)
- Inicialização do mapa e rastreamento de localização em tempo real
- Integração planejada com grade hexagonal via H3 para territorialização

---

## 🛠 Como rodar o projeto

### 1. Pré-requisitos

- Flutter instalado e configurado no PATH
- Dispositivo ou emulador/web browser disponível

### 2. Instale dependências

```bash
flutter pub get
