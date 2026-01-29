import axios from "axios";

const API_URL = "http://localhost:3000/api/v1";

const usersService = {
  // Listar todos os usuários
  getUsers() {
    return axios.get(`${API_URL}/users`, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
  },

  // Obter usuário por ID
  getUserById(userId) {
    return axios.get(`${API_URL}/users/${userId}`, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
  }
};

export default usersService;