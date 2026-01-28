<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import { createConsumer } from "@rails/actioncable";
import messagesService from "../services/messagesService";

// Estado do componente
const messageText = ref("");
const messages = ref([]);
let subscription = null;
let consumer = null;

// Identificadores (Em um app real, viriam da autenticação)
const meuUsuarioId = localStorage.getItem("user_id") ? JSON.parse(localStorage.getItem("user_id")) : 1; 
const idDoAmigo = 2;

onMounted(async () => {
  // 1. Carregar histórico inicial (GET /messages/{user_id})
  try {
    const response = await messagesService.getMessages(meuUsuarioId);
    messages.value = response.data;
    console.log("Histórico carregado:", response.data);
  } catch (error) {
    console.error("Erro ao carregar histórico:", error);
  }

  // 2. Conectar ao ActionCable para receber novas mensagens
  // Passamos o meu ID para o Rails saber em qual stream me colocar
  consumer = createConsumer(`ws://localhost:3000/cable`);

  subscription = consumer.subscriptions.create("MessagesChannel", {
    received(data) {
      // Quando alguém me envia algo, o Rails dá o broadcast e cai aqui
      console.log("Mensagem recebida via WebSocket:", data);
      messages.value.push(data);
    }
  });
});

const enviarDados = async () => {
  if (messageText.value.trim() === "") return;

  try {

    const payload = {
      sender_id: meuUsuarioId,
      receiver_id: idDoAmigo,
      content: messageText.value
    };

    const response = await messagesService.sendMessage(payload);

    // 👉 SOMENTE enquanto o WebSocket estiver desligado
    //messages.value.push(response.data);

    messageText.value = "";
  } catch (error) {
    console.error("Erro ao enviar mensagem:", error);
  }
};

onUnmounted(() => {
  if (subscription) subscription.unsubscribe();
  if (consumer) consumer.disconnect();
});
</script>

<template>
  <header><h1>Voll Chat</h1></header>
  <div class="message-container">
    <div class="messages-list">
      <div 
        v-for="(msg, index) in messages" 
        :key="index" 
        :class="['message', msg.sender_id === meuUsuarioId ? 'sent' : 'received']"
      >
        <div class="content">{{ msg.content }}</div>
        <div class="timestamp">
          {{ new Date(msg.created_at).toLocaleTimeString() }}
        </div>
      </div>
    </div>
    
    <div class="input-area">
      <input v-model="messageText" @keyup.enter="enviarDados" placeholder="Digite..." />
      <button @click="enviarDados">Enviar</button>
    </div>
  </div> 
</template>

<style scoped>
/* Estilos para diferenciar enviado/recebido */
.message-container { display: flex; flex-direction: column; height: 80vh; }
.messages-list { flex: 1; overflow-y: auto; padding: 1rem; background: #6b6767; display: flex; flex-direction: column; }
.message { margin-bottom: 0.8rem; padding: 0.6rem; border-radius: 8px; max-width: 60%; }
.sent { background-color: #42b983; color: rgb(168, 66, 66); align-self: flex-end; }
.received { background-color: #ffffff; color: #333; align-self: flex-start; border: 1px solid #ddd; }
.timestamp { font-size: 0.7rem; opacity: 0.7; display: block; margin-top: 4px; }
.input-area { display: flex; padding: 1rem; }
input { flex: 1; padding: 0.5rem; margin-right: 0.5rem; }
button { background: #42b983; color: white; border: none; padding: 0.5rem 1rem; cursor: pointer; }
</style>
