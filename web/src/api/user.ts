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
