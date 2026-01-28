<script setup>
import { RouterLink, RouterView } from 'vue-router'
import ChatView from './views/ChatView.vue';
</script>

<template>
  <main>
    <RouterView />
  </main>
</template>

<style scoped>
body {
  margin: 0;
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
main {
  width: 100%;
  background-color: aquamarine;
}
</style>
