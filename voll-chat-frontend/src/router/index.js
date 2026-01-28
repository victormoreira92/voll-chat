import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/chat',
      name: 'chat',
      meta: { requiresAuth: true },
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/ChatView.vue'),
    },
    {
      path: '/',
      name: 'login',
      meta: { requiresAuth: false },
      component: () => import('../views/LoginView.vue'),
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
