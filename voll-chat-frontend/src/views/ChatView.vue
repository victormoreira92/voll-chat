<script setup>
import Message from '@/components/Message.vue';
import Room from '@/components/Room.vue';
</script>

<template>
  <div class="chat-layout">
    <div class="sidebar">
      <Room />
    </div>
    <div class="chat-main">
      <Message />
    </div>
  </div>
</template>

<style scoped>
.chat-layout {
  display: flex;
  height: 100vh;
  gap: 1rem;
  padding: 1rem;
  background-color: #f5f5f5;
}

.sidebar {
  flex-shrink: 0;
  overflow-y: auto;
}

.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  height: 90%;
  padding: 20px 0;
  background: white;
  border-radius: 8px;
}

@media (max-width: 768px) {
  .chat-layout {
    flex-direction: column;
  }

  .sidebar {
    flex-shrink: 1;
    max-height: 300px;
  }

  .chat-main {
    flex: 1;
  }
}
</style>
