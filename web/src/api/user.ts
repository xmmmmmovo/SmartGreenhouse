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

export const createRole = (data: any) =>
  request({

  })

export const updateRole = (id:number, data: any) =>
  request({

  })

export const deleteRole = (id:number) =>
  request({

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
