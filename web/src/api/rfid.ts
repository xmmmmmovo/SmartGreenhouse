import { IRFIDData } from '@/api/types'
import request from '@/utils/request'

export const defaultSensorData: IRFIDData = {
  username: '',
  log_time: '',
  hardware_uuid: '',
  name: ''
}

export const getRFIDData = (params: any) =>
  request({
    url: '/rfid/get_data',
    method: 'get',
    params
  })
