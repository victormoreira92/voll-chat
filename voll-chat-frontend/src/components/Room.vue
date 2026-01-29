<script setup>
import { ref, onMounted, computed} from 'vue';
import { useRouter, useRoute} from 'vue-router';
import usersService from '@/services/usersService';


const router = useRouter();
const route = useRoute();
const users = ref([]);
const carregando = ref(true);
const erro = ref('');
const currentUserId = ref(localStorage.getItem('user_id'));
const emit = defineEmits(["select-user"]);

const selectUser = (userId) => {
  emit("select-user", userId);
};
onMounted(async () => {
  try {
    const response = await usersService.getUsers();
    // Filtrar o usuário atual da lista
    users.value = response.data.filter(user => user.id !== parseInt(currentUserId.value));
    carregando.value = false;
    console.log('Usuários carregados:', users.value);
  } catch (error) {
    console.error('Erro ao carregar usuários:', error);
    erro.value = 'Erro ao carregar usuários';
    carregando.value = false;
  }
});

const usuarioAtivoId = computed(() =>
  Number(route.params.receiver_id)
);

const abrirChat = (userId) => {
  emit("select-user", userId);

  router.push({
    name: 'chat-user',
    params: { 
      receiver_id: userId
    }
  }).then(() => {
    window.location.reload();
  });

};
</script>

<template>
  <div class="users-container">
    <h2>Users</h2>
    
    <div v-if="carregando" class="carregando">
      Carregando usuários...
    </div>

    <div v-if="erro" class="erro-mensagem">
      {{ erro }}
    </div>

    <ul v-if="!carregando && users.length > 0" class="users-list">
      <li 
        v-for="user in users" 
        :key="user.id"
        :class="{ active: user.id === usuarioAtivoId }"
        class="user-item"
        @click="abrirChat(user.id)"
      >
        <div class="user-info">
          <span class="user-name">{{ user.name }}</span>
        </div>
        <span class="status-indicator"></span>
      </li>
    </ul>

    <div v-if="!carregando && users.length === 0" class="vazio">
      Nenhum usuário disponível
    </div>
  </div>
</template>

<style scoped>
.users-container {
  width: 100%;
  max-width: 400px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

h2 {
  padding: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  margin: 0;
  font-size: 1.1rem;
}

.carregando,
.vazio {
  padding: 2rem 1rem;
  text-align: center;
  color: #999;
  font-size: 0.9rem;
}

.erro-mensagem {
  padding: 1rem;
  background-color: #fee;
  color: #c33;
  border-left: 4px solid #c33;
  margin: 0;
}

.users-list {
  list-style: none;
  padding: 0;
  margin: 0;
  max-height: 500px;
  overflow-y: auto;
}

.user-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: background-color 0.2s;
}

.user-item:hover {
  background-color: #f5f5f5;
}

.user-item:last-child {
  border-bottom: none;
}

.user-info {
  display: flex;
  flex-direction: column;
  flex: 1;
}

.user-name {
  font-weight: 600;
  color: #333;
  font-size: 0.95rem;
}

.user-email {
  color: #999;
  font-size: 0.8rem;
  margin-top: 0.25rem;
}

.status-indicator {
  width: 12px;
  height: 12px;
  background-color: #4caf50;
  border-radius: 50%;
  margin-left: 0.75rem;
  flex-shrink: 0;
}
.user-item.active {
  background-color: #bebebe;
  box-shadow: 0 0 10px rgba(202, 204, 203, 0.6);
}
</style>