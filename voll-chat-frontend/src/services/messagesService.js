import axios from "axios";

const API_URL = "http://localhost:3000/api/v1";

const messagesService = {
  // Enviar mensagem
  sendMessage(messageData) {
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
  ,

  // Enviar mensagem com imagem
  sendMessageWithImage(formData) {
    return axios.post(`${API_URL}/messages`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });
  }


};

export default messagesService;