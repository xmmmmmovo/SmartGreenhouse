import { IHardwareData } from '@/api/types'
import request from '@/utils/request'

export const defaultHardwareData: IHardwareData = {
  humidity_limit: 50.00,
  name: 'noname',
  temperature_limit: 35.00,
  up: false,
  uuid: '',
  id: 0
}

export const getHardwareList = (params: any) =>
  request({
    url: '/hardware/get_hardware',
    method: 'get',
    params
  })

export const updateHardwareData = (id: number, data: any) =>
  request({
    url: `/hardware/hardware/${id}`,
    method: 'put',
    data
  })

export const deleteHardwareData = (id: number, params:any) =>
  request({
    url: `/hardware/hardware/${id}`,
    method: 'delete',
    params
  })
