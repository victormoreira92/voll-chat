import axios from "axios";

const API_URL = "http://localhost:3000/api/v1/users/login";

const authenticationService = {
  // Função de login
  login(credentials) {
    return axios.post(API_URL, {
      user: credentials
    });
  }
};

export default authenticationService;