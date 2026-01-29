<script setup>
import { RouterLink, RouterView } from 'vue-router'
import ChatView from './views/ChatView.vue';
</script>

<template>
  <header>
    <h1>Voll Chat</h1>
  </header>
  <main>
    <RouterView />
  </main>
</template>

<style scoped>
  header {
    background-color: #0a2ed2;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  h1{
    margin: 0;
    padding: 1rem;
    color: white;
    text-align: center;
  }
  main {
    background-color: rgb(170, 200, 255);
    padding: 1rem;
  }

</style>
