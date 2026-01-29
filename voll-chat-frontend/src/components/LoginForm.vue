<script setup>
import { ref, computed } from "vue";
import { useRouter, useRoute } from "vue-router";
import  authenticationService  from "../services/authentication";

const router = useRouter();
const route = useRoute();
const email = ref("");
const password = ref("");
const erro = ref("");
const carregando = ref(false);
const authAlert = computed(() => route.query.alert === 'unauthorized');

const fazerLogin = async () => {
  // Validações
  if (!email.value.trim()) {
    erro.value = "Email is required";
    return;
  }
  
  if (!password.value.trim()) {
    erro.value = "Password is required";
    return;
  }

  carregando.value = true;
  erro.value = "";

  try {
    const payload = {
      email: email.value,
      password: password.value
    };
    const response = await authenticationService.login(payload);

    if (response.data.token && response.data.user_id) {
      localStorage.setItem("token", response.data.token);
      localStorage.setItem("user_id", JSON.stringify(response.data.user_id));
      
      router.push({ name: "chat"});
    }
  } catch (err) {
    console.error(err);
    erro.value = err.response?.data?.message || "Error in authentication";
  } finally {
    carregando.value = false;
  }
};

</script>

<template>
  <div class="container">
    <div class="login-container">
      <div class="login-box">
        <p class="subtitle">Faça login para continuar</p>

        <!-- Mensagem de erro -->
        <div v-if="erro" class="erro-mensagem">
          {{ erro }}
        </div>
      
        <div v-if="authAlert" class="erro-mensagem">
        Please log in to access the chat
        </div>

        <!-- Formulário -->
        <form @submit.prevent="fazerLogin">
          <div class="form-group">
            <label for="email">Email:</label>
            <input
              id="email"
              v-model="email"
              type="email"
              placeholder="email@email.com"
              :disabled="carregando"
            />
          </div>

          <div class="form-group">
            <label for="senha">Password:</label>
            <input
              id="senha"
              v-model="password"
              type="password"
              placeholder="Your password"
              :disabled="carregando"
            />
          </div>

          <button 
            type="submit" 
            class="btn-login"
            :disabled="carregando"
          >
            {{ carregando ? "Carregando..." : "Entrar" }}
          </button>
        </form>    
      </div>
    </div>
  </div>
</template>

<style scoped>
.container{
  height: 100vh;
}

.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.login-box {
  background: white;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  width: 100%;
  max-width: 400px;
}

h1 {
  color: #667eea;
  text-align: center;
  margin-bottom: 0.5rem;
  font-size: 2rem;
}

.subtitle {
  text-align: center;
  color: #666;
  margin-bottom: 1.5rem;
  font-size: 0.9rem;
}

.erro-mensagem {
  background-color: #fee;
  color: #c33;
  padding: 0.75rem;
  border-radius: 5px;
  margin-bottom: 1rem;
  border-left: 4px solid #c33;
  font-size: 0.9rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  color: #333;
  font-weight: 500;
}

input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

input:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
}

input:disabled {
  background-color: #f5f5f5;
  cursor: not-allowed;
}

.btn-login {
  width: 100%;
  padding: 0.75rem;
  background-color: #667eea;
  color: white;
  border: none;
  border-radius: 5px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-login:hover:not(:disabled) {
  background-color: #5568d3;
}

.btn-login:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.cadastro-link {
  text-align: center;
  margin-top: 1.5rem;
  font-size: 0.9rem;
}

.cadastro-link p {
  color: #666;
}

.link-btn {
  background: none;
  border: none;
  color: #667eea;
  cursor: pointer;
  text-decoration: underline;
  font-weight: 600;
  padding: 0;
  font-size: inherit;
}

.link-btn:hover {
  color: #5568d3;
}
</style>
