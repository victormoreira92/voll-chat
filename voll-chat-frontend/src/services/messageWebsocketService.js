const API_URL = "http://localhost:3000/api/v1";
const messageWebsocketService = {
  connectWebSocket(userId, onMessageReceived) {
    const ws = new WebSocket("ws://localhost:3000/cable");
    
    ws.onopen = () => {
      console.log("WebSocket conectado");
      // Subscrever ao canal de mensagens
      ws.send(JSON.stringify({
        command: "subscribe",
        identifier: JSON.stringify({
          channel: "MessagesChannel",
          userId: userId
        })
      }));
    };

    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      // Verificar se é uma mensagem do canal
      if (data.message) {
        onMessageReceived(data.message);
      }
    };

    ws.onerror = (error) => {
      console.error("WebSocket erro:", error);
    };

    ws.onclose = () => {
      console.log("WebSocket desconectado");
    };

    return ws;
  }
}

export default messageWebsocketService;
