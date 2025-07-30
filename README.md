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

3. Rodar no navegador (Chrome)

```bash
flutter run -d chrome

4. Rodar no Windows (desktop)
Habilite o suporte a Windows se ainda não tiver feito:

```bash
flutter config --enable-windows-desktop
flutter devices
flutter run -d windows

📁 Estrutura do Projeto

```bash
track_run/
│
├── lib/
│   └── main.dart          # Ponto de entrada do app, com mapa OSM inicializado
├── pubspec.yaml           # Dependências e metadados do projeto
├── .gitignore             # Arquivos ignorados pelo Git
└── README.md              # Este arquivo
📌 Status
🧪 Em desenvolvimento inicial — ainda não possui backend, persistência nem sistema de territórios ativado.

📍 Próximos passos
Implementar grade hexagonal usando H3 para marcação de territórios

Adicionar persistência local e/ou em nuvem

Criar sistema de contas e rankings

Integração com Firebase ou Supabase

Interface para histórico e estatísticas

👨‍💻 Desenvolvedor
Juliano Klak — github.com/JulianoKlak

🌍 Licença
Este projeto é open-source, licenciado sob a MIT License.