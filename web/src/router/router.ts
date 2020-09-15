import Vue from 'vue'
import Router, { RouteConfig } from 'vue-router'
import Layout from '@/layout/index.vue'

Vue.use(Router)

/*
  name:'router-name'             the name field is required when using <keep-alive>, it should also match its component's name property
                                 detail see : https://vuejs.org/v2/guide/components-dynamic-async.html#keep-alive-with-Dynamic-Components
  redirect:                      if set to 'noredirect', no redirect action will be trigger when clicking the breadcrumb
  meta: {
    roles: ['admin', 'editor']   will control the page roles (allow setting multiple roles)
    title: 'title'               the name showed in subMenu and breadcrumb (recommend set)
    icon: 'svg-name'             the icon showed in the sidebar
    hidden: true                 if true, this route will not show in the sidebar (default is false)
    alwaysShow: true             if true, will always show the root menu (default is false)
                                 if false, hide the root menu when has less or equal than one children route
    breadcrumb: false            if false, the item will be hidden in breadcrumb (default is true)
    noCache: true                if true, the page will not be cached (default is false)
    affix: true                  if true, the tag will affix in the tags-view
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
*/

export const constantRoutes: RouteConfig[] = [
  {
    path: '/login',
    component: () => import(/* webpackChunkName: "login" */ '@/views/login/index.vue'),
    meta: {
      title: '登录界面',
      hidden: true
    }
  },
  {
    path: '/404',
    component: () => import(/* webpackChunkName: "404" */ '@/views/404.vue'),
    meta: { hidden: true }
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        component: () => import(/* webpackChunkName: "dashboard" */ '@/views/dashboard/index.vue'),
        name: 'Dashboard',
        meta: {
          title: '控制台',
          icon: 'dashboard',
          affix: true
        }
      }
    ]
  },
  {
    path: '/hardware',
    component: Layout,
    redirect: '/hardware/hardware',
    children: [
      {
        path: 'hardware',
        component: () => import('@/views/hardware/index.vue'),
        name: 'Hardware',
        meta: {
          title: '客户端状态',
          icon: 'hardware',
          affix: true
        }
      }
    ]
  },
  {
    path: '/info',
    component: Layout,
    redirect: '/info/sensor',
    meta: {
      title: '信息管理',
      icon: 'info',
      affix: true
    },
    children: [
      {
        path: 'sensor',
        component: () => import('@/views/info/sensor/index.vue'),
        name: 'Sensor',
        meta: {
          title: '传感器信息',
          icon: 'sensor',
          affix: true
        }
      },
      {
        path: 'rfid',
        component: () => import('@/views/info/rfid/index.vue'),
        name: 'RFID',
        meta: {
          title: 'RFID记录信息',
          icon: 'rfid',
          affix: true
        }
      }
    ]
  },
  {
    path: '*',
    redirect: '/404',
    meta: { hidden: true }
  }
]

/**
 * asyncRoutes
 * the routes that need to be dynamically loaded based on user roles
 */
export const asyncRoutes: RouteConfig[] = [
  {
    path: '/user',
    component: Layout,
    redirect: '/user/admin',
    meta: {
      title: '人员管理',
      icon: 'user',
      affix: true,
      roles: ['admin']
    },
    children: [
      {
        path: 'admin',
        component: () => import(/* webpackChunkName: "dashboard" */ '@/views/user/admin/index.vue'),
        name: 'Admin',
        meta: {
          title: '用户管理',
          icon: 'manage',
          affix: true
        }
      },
      {
        path: 'permission',
        component: () => import(/* webpackChunkName: "dashboard" */ '@/views/user/permission/index.vue'),
        name: 'Permission',
        meta: {
          title: '权限管理',
          icon: 'permission',
          affix: true
        }
      },
      {
        path: 'distribute',
        component: () => import(/* webpackChunkName: "dashboard" */ '@/views/user/distribution/index.vue'),
        name: 'Distribute',
        meta: {
          title: '人员派发',
          icon: 'distribute',
          affix: true
        }
      }
    ]
  }
]

const createRouter = () => new Router({
  // mode: 'history',  // Disabled due to Github Pages doesn't support this, enable this if you need.
  scrollBehavior: (to, from, savedPosition) => {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  },
  base: process.env.BASE_URL,
  routes: constantRoutes
})

const router = createRouter()

export function resetRouter() {
  const newRouter = createRouter();
  (router as any).matcher = (newRouter as any).matcher // reset router
}

export default router
