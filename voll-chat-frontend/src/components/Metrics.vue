<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";

const API_URL = "http://localhost:3000/api/v1";

// estado
const loading = ref(true);
const metrics = ref({
  total_users: 0,
  total_messages: 0,
  users: [],
  messages_today: 0,
});

// carregar métricas
const fetchMetrics = async () => {
  try {
    const response = await axios.get(`${API_URL}/metrics`, {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("token")}`
      }
    });
    console.log(response.data)
    metrics.value = response.data;
  } catch (error) {
    console.error("Erro ao carregar métricas:", error);
  } finally {
    loading.value = false;
  }
};

onMounted(fetchMetrics);
</script>

 <template>
  <div class="container">
    <div class="metrics-container">
      <h2>📊 Metrics</h2>

      <div v-if="loading" class="loading">
        Loading metrics...
      </div>

      <div v-else class="cards">
        <div class="card">
          <h3>Total Users</h3>
          <span>{{ metrics.total_users }}</span>
        </div>

        <div class="card">
          <h3>Total Messages</h3>
          <span>{{ metrics.total_messages }}</span>
        </div>

        <div class="card">
          <h3>Messages Today</h3>
          <span>{{ metrics.messages_today  }}</span>
        </div>
      </div>

      <div class="top-users" v-if="metrics.users.length">
        <h3>Stats Users</h3>

        <div class="stats-table">
          <div class="table-header">
            <span>User Name</span>
            <span>Received</span>
            <span>Sent</span>
          </div>
          
          <div v-for="user in metrics.users" :key="user.id" class="table-row">
            <span class="user-name">👤 {{ user.name }}</span>
            <span class="count">{{ user.messages_received }} <small>msgs</small></span>
            <span class="count">{{ user.messages_sent }} <small>msgs</small></span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.container {
  height: 100vh;
  display: flex;
  justify-content: center;
  color: black
}
.metrics-container {
  background-color: rgb(41, 91, 244);
  padding: 1rem 2rem;
  height: 80%;
  min-height: 40%;
}

.cards {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}

.card {
  background: #1e1e1e;
  color: white;
  padding: 1rem;
  border-radius: 8px;
  min-width: 180px;
  text-align: center;
}

.card span {
  font-size: 2rem;
  font-weight: bold;
}

.top-users {
  margin-top: 2rem;
}

.loading {
  opacity: 0.7;
}
.metrics-container {
  background-color: rgb(41, 91, 244);
  padding: 2rem;
  border-radius: 12px;
  color: white; /* Texto branco para contrastar com o fundo azul */
}

/* Nova estrutura de tabela/grid */
.stats-table {
  margin-top: 1rem;
  background: rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  overflow: hidden;
}

.table-header {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  padding: 10px;
  background: rgba(0, 0, 0, 0.2);
  font-weight: bold;
  font-size: 0.9rem;
  text-transform: uppercase;
}

.table-row {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  padding: 12px 10px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  align-items: center;
}

.table-row:last-child {
  border-bottom: none;
}

.user-name {
  font-weight: 500;
}

.count {
  font-family: monospace;
  font-size: 1.1rem;
}

.count small {
  font-size: 0.7rem;
  opacity: 0.7;
}
</style>
