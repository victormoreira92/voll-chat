<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import { createConsumer } from "@rails/actioncable";
import messagesService from "../services/messagesService";
import authenticationService from "@/services/authentication";
import { useRoute } from "vue-router";

// Estado do componente
const messageText = ref("");
const route = useRoute();
const messages = ref([]);
const fileInput = ref(null);
let subscription = null;
let consumer = null;

// Identificadores (Em um app real, viriam da autenticação)
const selectedUserId = ref(null);
const senderId = ref(null);
const meuUsuarioId = localStorage.getItem("user_id") ? JSON.parse(localStorage.getItem("user_id")) : 1;

const loadConversation = async () => {
  senderId.value = meuUsuarioId
  selectedUserId.value = Number(route.params.receiver_id);
  try {
    const response = await messagesService.getMessages(senderId.value, selectedUserId.value);
    messages.value = response.data;
  } catch (error) {
    console.error("Erro ao carregar histórico:", error);
  }
};

onMounted(async () => {
  await loadConversation();

  // 2. Conectar ao ActionCable para receber novas mensagens
  // Passamos o meu ID para o Rails saber em qual stream me colocar
  consumer = createConsumer(`ws://localhost:3000/cable`);

  subscription = consumer.subscriptions.create(
  { channel: "MessagesChannel", user_id: meuUsuarioId },
  {
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
      receiver_id: Number(route.params.receiver_id),
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

const handleFileUpload = async (event) => {
  const file = event.target.files[0];
  if (!file) return;

  const formData = new FormData();
  formData.append("message[sender_id]", meuUsuarioId);
  formData.append("message[receiver_id]", idDoAmigo);
  formData.append("message[image]", file);

  try {
    const response = await messagesService.sendMessageWithImage(formData);
    console.log("Imagem enviada com sucesso:", response.data);
  } catch (error) {
    console.error("Erro ao enviar imagem:", error);
  } finally {
    // Limpar o input de arquivo para permitir reenvio do mesmo arquivo se necessário
    fileInput.value.value = "";
  }
};

const logout = () => {
  authenticationService.logout();
  window.location.href = "/";
};

onUnmounted(() => {
  if (subscription) subscription.unsubscribe();
  if (consumer) consumer.disconnect();
});
</script>

<template><button 
    class="logout-button" 
    @click="logout">
    Logout
  </button>
  <div class="message-container">
    <div class="messages-list">
      <div 
        v-for="(msg, index) in messages" 
        :key="index" 
        :class="['message', msg.sender_id === meuUsuarioId ? 'sent' : 'received']"
      >
        <div class="content">{{ msg.content }}</div>
        <div v-if="msg.image_url" class="message-image">
          <img :src="msg.image_url" alt="Sent image" @click="openFullscreen(msg.image_url)" />
        </div>
        <div class="timestamp">
          {{ new Date(msg.created_at).toLocaleTimeString() }}
        </div>
      </div>
    </div>
    
    <div class="input-area">
      <input v-model="messageText" 
             @keyup.enter="enviarDados" 
             placeholder="Digite..." />

      <input 
        type="file" 
        id="file-upload" 
        ref="fileInput" 
        @change="handleFileUpload" 
        accept="image/*" 
        style="display: none" 
      />

      <label for="file-upload" class="icon-btn" title="Upload Image">
        📎
      </label>
      <button class="btn-send" @click="enviarDados">Send</button>
    </div>
  </div> 
</template>

<style scoped>
/* Estilos para diferenciar enviado/recebido */
.message-container { 
  display: flex; 
  flex-direction: 
  column; height: 80vh; 
}

.messages-list { 
  flex: 1; 
  overflow-y: auto; 
  padding: 1rem; 
  background: #818181; 
  display: flex; 
  flex-direction: column; 
}

.message { 
  margin-bottom: 0.8rem; 
  padding: 0.6rem; 
  border-radius: 8px; 
  max-width: 60%; 
}

.sent { 
  background-color: #42b983; 
  color: rgb(168, 66, 66); 
  align-self: flex-end; 
}

.received { 
  background-color: #ffffff; 
  color: #333; 
  align-self: flex-start; 
  border: 1px solid #ddd; 
}

.timestamp { 
  font-size: 0.7rem; 
  opacity: 0.7; 
  display: block; 
  margin-top: 4px; 
}

.input-area { 
  display: flex; 
  padding: 1rem; 
}

input { 
  flex: 1; 
  padding: 0.5rem; 
  margin-right: 0.5rem; 
}

.message-image img {
  max-width: 100%;      /* Não deixa a imagem sair do balão */
  max-height: 300px;    /* Limita a altura para não ocupar a tela toda */
  border-radius: 8px;   /* Arredonda os cantos da foto */
  display: block;
  margin-top: 5px;
  cursor: pointer;      /* Mostra que é clicável */
  object-fit: cover;    /* Mantém a proporção */
}
.logout-button {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: #ff4d4f;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  cursor: pointer;
}
.logout-button:hover {
  background-color: #ff7875;
}

.btn-send {
  background-color: #42b983;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  cursor: pointer;
}

.btn-send:hover {
  background-color: #369870;
}

.icon-btn {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.5rem;
  margin-right: 0.5rem;
}
</style>
