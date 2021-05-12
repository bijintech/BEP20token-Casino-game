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
      },
      {
        path: 'faq',
        component: () => import('@/views/FAQ')
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

const DEFAULT_TITLE = 'Play The Best Crypto Dice Game: Start Earning Crypto With A New Blockchain Social Gaming Experience';
router.afterEach((to, from) => {
    Vue.nextTick(() => {
        console.log(to, from)
        document.title = DEFAULT_TITLE;
    });
});

export default router
