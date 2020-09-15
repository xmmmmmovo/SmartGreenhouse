import { IRoleData, IUserData } from '@/api/types'
import request from '@/utils/request'

export const defaultUserData: IUserData = {
  id: 0,
  username: '',
  name: ''
}

export const defaultRoleData: IRoleData = {
  id: 0,
  name: ''
}

export const getUserData = (params: any) =>
  request({
    url: '/user/get_data',
    method: 'get',
    params
  })

export const getRolesData = (params: any) =>
  request({
    url: '/user/roles',
    method: 'get',
    params
  })

export const getAllRolesData = () =>
  request({
    url: '/user/roles/all',
    method: 'get'
  })

export const createRole = (data: any) =>
  request({
    url: '/user/add_role',
    method: 'post',
    data
  })

export const updateRole = (id:number, data: any) =>
  request({
    url: `user/roles/${id}`,
    method: 'put',
    data
  })

export const deleteRole = (id:number) =>
  request({
    url: `user/roles/${id}`,
    method: 'delete'
  })

export const deleteUserData = (id: number) =>
  request({
    url: `/user/user/${id}`,
    method: 'delete'
  })

export const updateUserData = (id: number, data: any) =>
  request({
    url: `/user/user/${id}`,
    method: 'put',
    data
  })

export const getAllUser = () =>
  request({
    url: '/user/user/all',
    method: 'get'
  })
