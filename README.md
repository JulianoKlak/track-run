# 🏃 Track Run — Corrida Territorial com Flutter + OpenStreetMap

Aplicativo em desenvolvimento inspirado em jogos como *Run An Empire*, com foco em conquistar território ao correr por regiões no mapa. Criado especialmente para o Brasil, usando tecnologias open-source.

---

## 🎯 Funcionalidades Implementadas

### ✅ Sistema de Autenticação
- **Login/Registro de usuários** — Sistema simples de autenticação local
- **Cores únicas por usuário** — Cada usuário recebe uma cor aleatória para identificação no mapa
- **Persistência de sessão** — Mantém o usuário logado entre sessões

### ✅ Rastreamento de Localização
- **Rastreamento em tempo real** — Captura a posição do usuário a cada 10 metros
- **Gravação de trajetos** — Salva coordenadas com timestamp no banco de dados local
- **Histórico de trajetos** — Visualize todos os seus percursos anteriores

### ✅ Conquista de Território
- **Hexágonos H3** — Uso da biblioteca H3 (Uber) para divisão do território em hexágonos
- **Marcação automática** — Hexágonos são automaticamente conquistados ao passar por eles
- **Visualização colorida** — Cada território conquistado é exibido no mapa com a cor do usuário
- **Persistência de territórios** — Territórios são salvos no banco de dados

### ✅ Visualização do Mapa
- **OpenStreetMap** — Mapas gratuitos sem necessidade de cartão de crédito
- **Marcadores personalizados** — Indicadores de início e fim de trajeto
- **Rotas traçadas** — Visualização completa do caminho percorrido
- **Múltiplos usuários** — Visualize territórios conquistados por diferentes usuários

### ✅ Banco de Dados Local
- **SQLite** — Armazenamento local usando sqflite
- **Tabelas estruturadas** — Users, Trajectories, Coordinates, Territories
- **Relacionamentos** — Foreign keys e índices para performance

---

## 🚀 Tecnologias Utilizadas

- **Flutter** — Framework para desenvolvimento mobile/web/desktop
- **flutter_map** — Pacote Flutter baseado em Leaflet, usa OpenStreetMap
- **geolocator** — Para obter localização do dispositivo em tempo real
- **permission_handler** — Gerenciamento de permissões de localização
- **h3_flutter** — Para divisão do mapa em hexágonos com a biblioteca H3 (Uber)
- **sqflite** — Banco de dados SQLite local para persistência
- **shared_preferences** — Armazenamento de preferências do usuário
- **uuid** — Geração de IDs únicos
- **intl** — Formatação de datas e números

---

## 📦 Estrutura do Projeto

```bash
track_run/
│
├── lib/
│   ├── main.dart                    # Ponto de entrada com verificação de autenticação
│   ├── database/
│   │   └── database_helper.dart     # Configuração do banco de dados SQLite
│   ├── models/
│   │   ├── user.dart                # Modelo de usuário
│   │   ├── trajectory.dart          # Modelo de trajeto
│   │   ├── coordinate.dart          # Modelo de coordenada
│   │   └── territory.dart           # Modelo de território
│   ├── services/
│   │   ├── auth_service.dart        # Serviço de autenticação
│   │   ├── user_service.dart        # CRUD de usuários
│   │   ├── trajectory_service.dart  # CRUD de trajetos
│   │   ├── coordinate_service.dart  # CRUD de coordenadas
│   │   ├── territory_service.dart   # CRUD de territórios
│   │   └── location_tracking_service.dart # Rastreamento de localização
│   ├── screens/
│   │   ├── login_screen.dart        # Tela de login/registro
│   │   ├── main_map_screen.dart     # Tela principal com mapa
│   │   ├── trajectory_history_screen.dart  # Histórico de trajetos
│   │   └── trajectory_detail_screen.dart   # Detalhes de um trajeto
│   └── (outros arquivos legados)
├── pubspec.yaml                     # Dependências e metadados
└── README.md                        # Este arquivo
```

---

---

## 🛠 Como rodar o projeto

### 1. Pré-requisitos

- Flutter instalado e configurado no PATH (versão >=3.22.0)
- SDK Dart >=3.8.0
- Dispositivo ou emulador/web browser disponível

### 2. Instale dependências

```bash
flutter pub get
```

### 3. Execute o aplicativo

#### Rodar no navegador (Chrome)

```bash
flutter run -d chrome
```

#### Rodar no Windows (desktop)

Habilite o suporte a Windows se ainda não tiver feito:

```bash
flutter config --enable-windows-desktop
flutter devices
flutter run -d windows
```

#### Rodar no Android/iOS

```bash
flutter run
```

---

## 📱 Como usar

1. **Registro/Login**
   - Abra o aplicativo e insira um nome de usuário
   - Clique em "Registrar" para criar uma nova conta ou "Entrar" se já tiver uma conta
   - Uma cor será automaticamente atribuída ao seu perfil

2. **Iniciar Rastreamento**
   - Na tela principal do mapa, clique no botão verde "Iniciar"
   - Permita o acesso à localização quando solicitado
   - Comece a caminhar ou correr — suas coordenadas serão registradas automaticamente

3. **Conquistar Territórios**
   - Conforme você se move, hexágonos aparecem no mapa com sua cor
   - Cada hexágono representa aproximadamente 15 metros de diâmetro
   - Territórios conquistados são salvos permanentemente

4. **Ver Histórico**
   - Clique no ícone de relógio (histórico) na barra superior
   - Veja todos os seus trajetos anteriores
   - Clique em um trajeto para ver detalhes e visualizar a rota no mapa

5. **Parar Rastreamento**
   - Clique no botão vermelho "Parar" para encerrar a sessão atual
   - O trajeto será salvo no histórico

---

## 🗺️ Estrutura do Banco de Dados

### Tabela: users
- `id` (TEXT PRIMARY KEY) — ID único do usuário
- `username` (TEXT) — Nome de usuário
- `color` (TEXT) — Cor em formato hexadecimal (#RRGGBB)
- `createdAt` (TEXT) — Data de criação

### Tabela: trajectories
- `id` (TEXT PRIMARY KEY) — ID único do trajeto
- `userId` (TEXT) — Referência ao usuário
- `name` (TEXT) — Nome do trajeto
- `startTime` (TEXT) — Data/hora de início
- `endTime` (TEXT) — Data/hora de término (nullable)
- `isActive` (INTEGER) — Se o trajeto está ativo (1) ou não (0)
- `distance` (REAL) — Distância em km (nullable)

### Tabela: coordinates
- `id` (INTEGER PRIMARY KEY AUTOINCREMENT) — ID único da coordenada
- `userId` (TEXT) — Referência ao usuário
- `trajectoryId` (TEXT) — Referência ao trajeto
- `latitude` (REAL) — Latitude
- `longitude` (REAL) — Longitude
- `timestamp` (TEXT) — Data/hora da captura
- `h3Index` (TEXT) — Índice H3 do hexágono (nullable)

### Tabela: territories
- `h3Index` (TEXT PRIMARY KEY) — Índice H3 do hexágono
- `userId` (TEXT) — Referência ao usuário que conquistou
- `conqueredAt` (TEXT) — Data/hora da conquista
- `color` (TEXT) — Cor do território

---

## 📌 Status

✅ **Sistema completo e funcional** com:
- Autenticação de usuários
- Rastreamento de localização em tempo real
- Persistência em banco de dados SQLite local
- Conquista e visualização de territórios
- Histórico de trajetos
- Suporte a múltiplos usuários

---

## 🔮 Próximos passos

- [ ] Implementar cálculo de distância percorrida
- [ ] Adicionar estatísticas por usuário (total de territórios, km percorridos, etc.)
- [ ] Sistema de conquista de quarteirões/bairros completos
- [ ] Integração com backend em nuvem (Firebase/Supabase)
- [ ] Sistema de rankings entre usuários
- [ ] Compartilhamento de trajetos nas redes sociais
- [ ] Notificações quando outros usuários passam perto
- [ ] Desafios e conquistas (achievements)

---

## 👨‍💻 Desenvolvedor

Juliano Klak — github.com/JulianoKlak

---

## 🌍 Licença

Este projeto é open-source, licenciado sob a MIT License.