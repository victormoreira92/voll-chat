import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/messages',
      name: 'chat',
      meta: { requiresAuth: true },
      component: () => import('../views/ChatView.vue'),
    },
    {
      path: '/messages/:receiver_id',
      name: 'chat-user',
      meta: { requiresAuth: true },
      component: () => import('../views/ChatView.vue'),
    },
    {
      path: '/',
      name: 'login',
      meta: { requiresAuth: false },
      component: () => import('../views/LoginView.vue'),
    },
    {
      path: '/metrics',
      name: 'metrics',
      meta: { requiresAuth: false },
      component: () => import('../views/MetricsView.vue'),

    }
  ],
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('token');

  if (to.meta.requiresAuth && !isAuthenticated) {
    next({ 
      name: 'login', 
      query: { alert: 'unauthorized' },
      replace: true
    });
  } else if (to.name === 'login' && isAuthenticated) {
    next({ name: 'chat' });
  } else {
    next();
  }
});

export default router
