import { IUserData } from '@/api/types'
import request from '@/utils/request'

export const defaultUserData: IUserData = {
  id: 0,
  username: '',
  name: ''
}

export const getUserData = (params: any) =>
  request({
    url: '/user/get_data',
    method: 'get',
    params
  })

export const getRolesData = () =>
  request({
    url: '/user/roles',
    method: 'get'
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
