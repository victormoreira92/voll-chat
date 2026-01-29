# 🚀 Voll Chat – Desafio Técnico Voll

Aplicação de **chat em tempo real** entre dois usuários, com envio de mensagens de texto e imagens, processadas de forma assíncrona e transmitidas via WebSockets.

![Badge em Desenvolvimento](https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow?style=for-the-badge)
![Badge Ruby on Rails](https://img.shields.io/badge/Rails-7.x-CC0000?style=for-the-badge&logo=ruby&logoColor=white)
![Badge Vue.js](https://img.shields.io/badge/Vue.js-3.x-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white)
![Badge Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)

## 🛠️ Tecnologias Utilizadas

- **Backend** → Ruby on Rails 7+ (modo API)
- **Frontend** → Vue 3 + Composition API + Vite
- **Comunicação em tempo real** → ActionCable (WebSockets)
- **Processamento assíncrono** → Sidekiq + Redis
- **Banco de dados** → PostgreSQL 15
- **Armazenamento de arquivos** → Active Storage (Disk local)
- **Containerização** → Docker + Docker Compose

## ✨ Funcionalidades Implementadas

- Cadastro e login de usuários
- Envio de mensagens de texto em tempo real
- Envio e exibição de imagens (com Active Storage)
- Processamento assíncrono de mensagens e mídia via Sidekiq
- Broadcast via ActionCable para os usuários envolvidos
- Tela de métricas: quantidade de mensagens enviadas por usuário
- Interface responsiva e moderna (Vue 3)

## 🏗️ Arquitetura e Fluxo Principal

1. Usuário envia mensagem (texto ou com imagem) via POST `/messages`
2. Rails persiste a mensagem e anexo (Active Storage)
3. Callback `after_commit` enfileira `BroadcastMessageJob` no Sidekiq
4. Sidekiq gera URL da imagem 
5. ActionCable transmite o payload para os canais privados dos usuários
6. Frontend recebe e exibe a mensagem em tempo real

## 📦 Como Rodar o Projeto com Docker (Recomendado)

### Pré-requisitos

- Docker e Docker Compose instalados

### Passo a passo

1. Clone o repositório

   ```bash
   git clone https://github.com/victormoreira92/voll-chat.git
   cd voll-chat

2. Inicie os containers

   ```bash
   docker-compose up --build
    ```
3. Acesse a aplicação no Frontend
   - Acesse http://localhost:5173/
   - Utilize os usuarios pré-cadastrados:
     - Usuário 1: 
        - email: `user1@email.com` 
        - password: `123456`

     - Usuário 2: 
        - email: `user2@email.com` 
        - password: `123456`
    - Para acessar o chat e as metrics é necessário logar
 ## Rotas Principais da API
- `POST /users/login` → Login de usuário
- `GET /users` → Listar usuários (autenticado)
- `POST /messages` → Enviar mensagem (autenticado)      
- `GET /messages` → Listar mensagens entre usuários (autenticado)
- `GET /metrics` → Obter métricas de mensagens por usuário (autenticado)
- `ws://localhost:3000/cable` → Canal WebSocket para mensagens em tempo real

## Desenvolvedor
- Victor Moreira

