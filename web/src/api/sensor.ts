import { ISensorData } from '@/api/types'
import request from '@/utils/request'

export const defaultSensorData: ISensorData = {
  id: 0,
  hardware_uuid: '',
  temperature: 30.00,
  humidity: 30.00,
  is_fire: false,
  is_dry: false,
  is_illum: false,
  record_time: '',
  name: ''
}

export const getSensorData = (params: any) =>
  request({
    url: '/sensor/get_data',
    method: 'get',
    params
  })

export const getDailySensorData = (params: any) =>
  request({
    url: '/sensor/get_data_hour',
    method: 'get',
    params
  })
