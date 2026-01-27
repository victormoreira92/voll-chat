<script setup>
import { RouterLink, RouterView } from 'vue-router'
import ChatView from './views/ChatView.vue';
</script>

<template>
  <ChatView />
</template>

<style scoped>
body {
  margin: 0;
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>
