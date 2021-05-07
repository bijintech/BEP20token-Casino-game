import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    component: () => import('@/layouts/Default'),
    children: [
      {
        path: '',
        component: () => import('@/views/Home')
      },
      {
        path: 'playgame',
        component: () => import('@/views/PlayGame')
      },
      {
        path: 'exchange',
        component: () => import('@/views/Exchange')
      },
      {
        path: 'liquidity',
        component: () => import('@/views/Liquidity')
      },
      {
        path: 'farming',
        component: () => import('@/views/Farming')
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
