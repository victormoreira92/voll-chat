import axios from "axios";

const API_URL = "http://localhost:3000/api/v1";

const messagesService = {
  // Enviar mensagem
  sendMessage(messageData) {
    console.log("Enviando mensagem:", messageData);
    return axios.post(`${API_URL}/messages`, {
      message: messageData
    });
  },

  // Receber mensagens com um usuário específico
  getMessages(userId) {
    return axios.get(`${API_URL}/messages`, {
      params: {
        user_id: userId
      }
    });
  }


};

export default messagesService;