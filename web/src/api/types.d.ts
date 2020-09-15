export interface IHardwareData {
  humidity_limit: number,
  name: string,
  temperature_limit: number,
  up: boolean,
  uuid: string,
  id: number
}

export interface ISensorData {
  id: number,
  hardware_uuid: string,
  temperature: number,
  humidity: number,
  is_fire: boolean,
  is_dry: boolean,
  is_illum: boolean,
  record_time: string
  name: string
}

export interface IRFIDData {
  username: string,
  log_time: string,
  hardware_uuid: string,
  name: string
}

export interface IUserData {
  id: number,
  username: string,
  name: string
}

export interface IRoleData {
  id: number,
  name: string
}
