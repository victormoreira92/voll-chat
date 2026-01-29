import axios from "axios";

const API_URL = "http://localhost:3000/api/v1";

const messagesService = {
  // Enviar mensagem
  sendMessage(messageData) {
  return axios.post(
    `${API_URL}/messages`,
    {
      message: messageData,
    },
    {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token')}`
      }
    }
  );
  },


  // Receber mensagens com um usuário específico
  getMessages(userId, receiverId) {
    return axios.get(`${API_URL}/messages`, {
      params: {
        sender_id: userId,
        receiver_id: receiverId
      },
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
  }
  ,

  // Enviar mensagem com imagem
  sendMessageWithImage(formData) {
    return axios.post(`${API_URL}/messages`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': `Bearer ${localStorage.getItem('token')}`

      }
    });
  }


};

export default messagesService;