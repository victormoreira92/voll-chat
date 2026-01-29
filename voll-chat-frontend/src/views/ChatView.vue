<script setup>
import Message from '@/components/Message.vue';
import Room from '@/components/Room.vue';
import { ref, onMounted, watch} from 'vue';
import { useRoute } from 'vue-router';


const route = useRoute();

// usuário logado
const currentUserId = ref(Number(localStorage.getItem("user_id")));

// usuário selecionado (conversa ativa)
const selectedUserId = ref(null);

// sincroniza com a rota ao carregar
onMounted(() => {
  if (route.params.receiver_id) {
    selectedUserId.value = Number(route.params.receiver_id);
  }
});

// reage quando a rota muda (clicar em outro user)
watch(
  () => route.params.receiver_id,
  (newReceiverId) => {
    selectedUserId.value = newReceiverId
      ? Number(newReceiverId)
      : null;
  }
);

// evento vindo do Room/UserList
const handleSelectUser = (userId) => {
  selectedUserId.value = userId;
};
</script>

<template>
  <div class="chat-layout">
    <div class="sidebar">
      <Room 
        :users="users"
        :selectedUserId="selectedUserId"
        @select-user="handleSelectUser"
      />
    </div>
    <div class="chat-main">
      <Message
        v-if="selectedUserId"
        :receiverId="selectedUserId"
        :senderId="currentUserId"

      />
      <div v-else class="empty-chat">
        Select a User to start a conversation
      </div>
    </div>
  </div>
</template>

<style scoped>
.chat-layout {
  display: flex;
  height: 100vh;
  gap: 1rem;
  padding: 1rem;
}

.sidebar {
  flex-shrink: 0;
  overflow-y: auto;
  width: 20%;
}

.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  height: 90%;
  padding: 20px;
  background: white;
  border-radius: 8px;
  width: 80%;
}
.empty-chat{
 color: black;
}
</style>
