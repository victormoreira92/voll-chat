<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import { createConsumer } from "@rails/actioncable";

import axios from "axios";

// ... dentro do seu <script setup>

const enviarDados = async () => {
  if (messageText.value.trim() === "") return;

  try {
    // 1. Enviamos para a API REST (não para o Cable diretamente)
    const response = await axios.post("http://localhost:3000/api/v1/messages", {
      message: {
        receiver_id: 2, // ID do usuário com quem você está conversando
        content: messageText.value
      }
    }, {
      // Se você estiver usando autenticação por Token/JWT

    });

    // 2. Adicionamos a nossa própria mensagem à lista local (opcional)
    messages.value.push({
      content: response.data.content,
      timestamp: response.data.created_at,
      sentByMe: true
    });

    messageText.value = ""; // Limpa o input
  } catch (error) {
    console.error("Erro ao enviar mensagem:", error);
  }
};


// // Estado do componente
// const messageText = ref("");
// const messages = ref([]);
// let subscription = null;
// let consumer = null;

// onMounted(() => {
//   // 1. Cria o consumidor conectando ao endpoint do Rails
//   // Ajuste a URL conforme seu ambiente (ex: localhost:3000)
//   consumer = createConsumer("ws://localhost:3000/cable");

//   // 2. Cria a subscrição no MessagesChannel
//   subscription = consumer.subscriptions.create("MessagesChannel", {
//     connected() {
//       console.log("Conectado ao MessagesChannel!");
//     },
//     disconnected() {
//       console.log("Desconectado do servidor.");
//     },
//     received(data) {
//       // Aqui você recebe o que o Rails envia via ActionCable.server.broadcast
//       console.log("Nova mensagem recebida:", data);
//       messages.value.push(data);
//     }
//   });
// });

// // 3. Limpeza ao destruir o componente
// onUnmounted(() => {
//   if (subscription) {
//     subscription.unsubscribe();
//   }
//   if (consumer) {
//     consumer.disconnect();
//   }
// });

// // Função para enviar dados (O comando 'consdes')
// const enviarDados = () => {
//   if (messageText.value.trim() === "" || !subscription) return;

//   // O método perform envia o comando 'consdes' para o Rails
//   subscription.perform("receive", {
//     content: messageText.value,
//     timestamp: new Date().toISOString(),
//   });

//   messageText.value = ""; // Limpa o campo
// };
</script>

<template>
  <header>
    <h1>Voll Chat</h1>
  </header>
  <div class="message-container">
    <div class="messages-list">
      <div 
        v-for="(msg, index) in messages" 
        :key="index" 
        class="message received"
      >
        <div class="content">{{ msg.content }}</div>
        <div class="timestamp">
          {{ new Date(msg.created_at).toLocaleTimeString() }}
        </div>
      </div>
    </div>
    
    <div class="input-area">
      <input 
        v-model="messageText" 
        @keyup.enter="enviarDados"
        type="text" 
        placeholder="Digite sua mensagem..." 
      />
      <button @click="enviarDados" :disabled="!messageText">Enviar</button>
    </div>
  </div> 
</template>

<style scoped>
/* Seus estilos originais permanecem os mesmos */
.message-container { display: flex; flex-direction: column; height: 80vh; }
.messages-list { flex: 1; overflow-y: auto; padding: 1rem; background: #888787; }
.message { margin-bottom: 0.5rem; padding: 0.5rem 1rem; border-radius: 8px; background: rgb(106, 105, 105); width: fit-content; }
.input-area { display: flex; padding: 1rem; border-top: 1px solid #ddd; }
input { flex: 1; padding: 0.5rem; border: 1px solid #ddd; border-radius: 4px; margin-right: 0.5rem; }
button { padding: 0.5rem 1rem; background-color: #42b983; color: white; border: none; cursor: pointer; }
header { background-color: #42b983; color: white; padding: 1rem; text-align: center; }
</style>
