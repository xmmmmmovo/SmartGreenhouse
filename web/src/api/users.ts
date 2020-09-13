import request from '@/utils/request'

export const getUserInfo = (data: any) =>
  request({
    url: '/user/info',
    method: 'post',
    data
  })

export const login = (data: any) =>
  request({
    url: '/user/login',
    method: 'post',
    data
  })

export const logout = () =>
  request({
    url: '/user/logout',
    method: 'delete'
  })
