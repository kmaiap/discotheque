# Discotheque - A Discoteca Pessoal & Colaborativa 🪩

> **Discotheque** é uma aplicação completa desenvolvida em **Flutter** e **Firebase**, arquitetada sob os princípios de **Clean Architecture** e **SOLID**, inspirada na estética retrô-futurista de clubes de vinil dos anos 80, synthwave e neon cyberpunk.

---

## 📋 Sumário
1. [Visão Geral e Funcionalidades](#-visão-geral-e-funcionalidades)
2. [Identidade Visual e Design System](#-identidade-visual-e-design-system)
3. [Arquitetura de Software (Clean Architecture & SOLID)](#-arquitetura-de-software)
4. [Modelagem de Dados no Cloud Firestore](#-modelagem-de-dados-no-cloud-firestore)
5. [Regras de Segurança Avançadas (firestore.rules)](#-regras-de-segurança-avançadas)
6. [Integração com APIs de Música](#-integração-com-apis-de-música)
7. [Passo a Passo de Instalação e Execução](#-passo-a-passo-de-instalação-e-execução)
8. [Configuração do Firebase (Console & FlutterFire)](#-configuração-do-firebase)

---

## 🌟 Visão Geral e Funcionalidades

- **Autenticação Segura**: Cadastro e login de usuários via Firebase Auth com persistência de perfil no Firestore.
- **Discotecas Colaborativas**: Criação de playlists compartilhadas com controle granular de permissões (Dono vs. Colaboradores).
- **Tempo Real com Firestore**: Atualização instantânea (`StreamBuilder`) ao adicionar músicas, remover faixas ou convidar curadores.
- **Busca Musical Integrada**: Consulta em tempo real à API externa de músicas (Deezer / Spotify) com prévia e capa em alta resolução.
- **Player & Vinil Animado**: Banner com disco de vinil giratório interativo, ondas de som animadas (equalizador sonoro) e doca de reprodução persistente.
- **Multiplataforma**: Suporte nativo para Web, Android, iOS e Desktop.

---

## 🎨 Identidade Visual e Design System

Baseada na estética retro-futurista de casas de vinil, a aplicação emprega a seguinte paleta neon:

| Elemento | Token | Valor Hexadecimal |
| :--- | :--- | :--- |
| **Fundo Principal** | `background` / `surface` | `#121317` |
| **Containers Escuros** | `surfaceContainerLow` | `#1A1B20` |
| **Primária (Magenta Neon)** | `primaryContainer` | `#FF4A8D` |
| **Destaque Primário** | `primary` | `#FFB1C4` |
| **Secundária (Violeta)** | `secondaryContainer` | `#6201C5` |
| **Terciária (Ciano Neon)** | `tertiary` | `#00DBE9` |
| **Texto de Alto Contraste** | `onSurface` | `#E3E2E8` |

- **Tipografia**: Space Grotesk para títulos e rótulos (`displayHero`, `headlineXl`, `labelCaps`) e Manrope para textos corridos (`bodyMd`, `bodySm`).

---

## 🏛️ Arquitetura de Software

O projeto segue estritamente a **Clean Architecture** e princípios **SOLID**:
- **Funções Curtas**: Todas as funções possuem menos de 20 linhas para manter máxima coesão e legibilidade.
- **Comentários em pt-BR**: Todos os arquivos contam com documentação e comentários em Português do Brasil.
- **Single Responsibility Principle (SRP)**: Separação clara entre camada de apresentação, estado e serviços externos.

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # URLs padrão e nomes de coleções
│   └── theme/
│       ├── app_colors.dart             # Paleta neon retrô-futurista
│       ├── app_text_styles.dart        # Space Grotesk e Manrope
│       └── app_theme.dart              # Tema escuro do Material 3
├── models/
│   ├── user_model.dart                 # Dados do perfil do usuário
│   ├── playlist_model.dart             # Entidade da Playlist e helpers
│   └── track_model.dart                # Faixa musical com capa e duração
├── services/
│   ├── auth_service.dart               # FirebaseAuth e sincronização
│   ├── firestore_service.dart          # CRUD e streams do Cloud Firestore
│   └── music_api_service.dart          # Integração HTTP com APIs de música
├── providers/
│   ├── auth_provider.dart              # Estado de login/cadastro
│   ├── playlist_provider.dart          # Gerenciamento de operações de playlist
│   ├── music_search_provider.dart      # Busca de faixas e estados assíncronos
│   └── audio_player_provider.dart      # Simulação de áudio e rotação de vinil
├── views/
│   ├── auth/
│   │   └── auth_screen.dart            # Login e cadastro com validações
│   ├── home/
│   │   ├── home_screen.dart            # Listagem de discotecas em tempo real
│   │   └── widgets/
│   │       ├── live_rooms_bar.dart     # Salas ativas ao vivo
│   │       ├── playlist_card.dart      # Card em estilo Bento
│   │       └── create_playlist_dialog.dart # Criação de nova discoteca
│   ├── playlist/
│   │   ├── playlist_detail_screen.dart # Hero com vinil giratório e faixas
│   │   └── widgets/
│   │       ├── vinyl_hero_widget.dart  # Disco de vinil animado (33 RPM)
│   │       ├── track_tile.dart         # Linha de música com equalizador
│   │       └── invite_collaborator_dialog.dart # Modal para convite por e-mail
│   ├── search/
│   │   └── music_search_screen.dart    # Busca de músicas e adição à discoteca
│   └── widgets/
│       ├── mini_player_dock.dart       # Barra persistente inferior
│       ├── equalizer_indicator.dart    # Barras de som animadas
│       └── custom_toast.dart           # Mensagens flutuantes neon
├── firebase_options.dart               # Configurações do Firebase
└── main.dart                           # Injeção de dependências e AuthGate
```

---

## 🗄️ Modelagem de Dados no Cloud Firestore

O Firestore foi estruturado com suporte nativo a relacionamentos muitos-para-muitos:

### 1. Coleção `users`
Armazena os perfis de cada usuário registrado:
```json
{
  "uid": "USER_FIREBASE_AUTH_UID",
  "email": "leo@discotheque.live",
  "displayName": "DJ Leo"
}
```

### 2. Coleção `playlists`
Armazena as discotecas e suas faixas embutidas:
```json
{
  "title": "Synthwave Afterhours",
  "description": "Sessão noturna retrô futurista",
  "ownerId": "UID_DO_DONO",
  "collaborators": ["UID_COLABORADOR_1", "UID_COLABORADOR_2"],
  "createdAt": "2026-10-27T14:00:00Z",
  "tracks": [
    {
      "id": "136336302",
      "title": "Midnight City",
      "artist": "M83",
      "albumCoverUrl": "https://e-cdns-images.dzcdn.net/images/cover/...",
      "durationMs": 243000,
      "previewUrl": "https://cdns-preview-d.dzcdn.net/stream/..."
    }
  ]
}
```

---

## 🔒 Regras de Segurança Avançadas (`firestore.rules`)

As regras no arquivo `firestore.rules` garantem a conformidade rigorosa com os requisitos do sistema:

1. **Criação de Playlists**: Usuários autenticados podem criar playlists apenas se definirem seu próprio UID como `ownerId`.
2. **Leitura Restrita**: Apenas o **Dono** (`request.auth.uid == resource.data.ownerId`) ou **Colaboradores convidados** (`request.auth.uid in resource.data.collaborators`) podem ler o documento.
3. **Edição de Faixas**: Tanto o Dono quanto os Colaboradores podem atualizar a lista `tracks`.
4. **Proteção de Integridade**: Colaboradores **não podem** alterar o campo `ownerId`, a data de criação `createdAt` nem o array `collaborators`.
5. **Exclusão e Gestão de Membros**: Apenas o **Dono** pode adicionar/remover colaboradores ou deletar a playlist.

---

## 🎵 Integração com APIs de Música

Por padrão, a aplicação vem configurada com a **Deezer Search API**, pois oferece:
- Busca pública direta de faixas, artistas e capas de álbuns.
- Links diretos para prévias de áudio (30 segundos).
- Sem necessidade de renovação contínua de tokens no ambiente de teste.

### Como Chavear para Spotify Web API (Opcional):
Caso deseje utilizar o Spotify:
1. Acesse o [Spotify Developer Dashboard](https://developer.spotify.com/dashboard).
2. Crie um app e obtenha seu `Client ID` e `Client Secret`.
3. Gere o token de autenticação Client Credentials (`https://accounts.spotify.com/api/token`).
4. Altere a URL base e o cabeçalho `Authorization: Bearer <TOKEN>` em `lib/services/music_api_service.dart`.

---

## 🚀 Passo a Passo de Instalação e Execução

### Pré-requisitos
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão `>= 3.0.0`)
- Git

### 1. Clonar ou Acessar a Pasta do Projeto
```bash
cd c:\Users\2DevSesi\Documents\kmaiap\mobile\discotheque
```

### 2. Instalar as Dependências do Flutter
```bash
flutter pub get
```

### 3. Executar o Projeto
- **Para executar no Navegador (Web)**:
  ```bash
  flutter run -d chrome
  ```
- **Para executar no Android/iOS**:
  ```bash
  flutter run
  ```

---

## ⚡ Configuração do Firebase

### 1. Criar Projeto no Firebase
1. Acesse o [Firebase Console](https://console.firebase.google.com/).
2. Clique em **Adicionar Projeto** e nomeie como `discotheque-app`.

### 2. Habilitar Autenticação
1. No menu lateral, clique em **Authentication** -> **Começar**.
2. Na aba **Método de login**, ative o provedor **E-mail/senha**.

### 3. Criar Banco de Dados Firestore
1. No menu lateral, clique em **Cloud Firestore** -> **Criar banco de dados**.
2. Na aba **Regras**, copie e cole o conteúdo de `firestore.rules` e clique em **Publicar**.

### 4. Vincular com FlutterFire CLI
Instale e rode a CLI oficial para gerar automaticamente as credenciais reais:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
Isso atualizará o arquivo `lib/firebase_options.dart` com as chaves reais do seu projeto.

---

## 💡 Validação do Fluxo de Uso

1. Abra a aplicação e clique em **"Novo por aqui? Criar conta"**.
2. Preencha seu nome, e-mail e senha e clique em **"Criar Conta"**.
3. Na tela principal, clique em **"Nova Playlist"** e crie sua primeira mesa de vinil.
4. Abra os detalhes da playlist, clique em **"Adicionar faixas"** e faça uma busca por faixas como *"Midnight City"*, *"The Midnight"* ou *"Gunship"*.
5. Adicione as músicas e observe o disco de vinil girar e as ondas de som do equalizador vibrarem na doca de reprodução inferior.
6. Convide um amigo informando o e-mail cadastrado dele para colaborar em conjunto na curadoria da playlist!

