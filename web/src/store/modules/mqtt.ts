import { VuexModule, Module, Action, Mutation, getModule } from 'vuex-module-decorators'
import store from '@/store'
import mqtt from 'mqtt'
import { Message } from 'element-ui'

export interface IMqttState {
  config: mqtt.IClientOptions
  url: string
  client: mqtt.Client
}

@Module({ dynamic: true, store, name: 'mqtt' })
class Mqtt extends VuexModule implements IMqttState {
  config = {
    clientId: '',
    username: 'emqx',
    password: 'public'
  }
  url = 'ws://www.fivezha.cn:8083/mqtt'
  // @ts-ignore
  client = null

  @Mutation
  private SET_CLIENT_ID(id: string) {
    this.config.clientId = id
  }

  @Mutation
  private SET_CLIENT(client: mqtt.Client) {
    // @ts-ignore
    this.client = client
  }

  @Action
  public async Connect(username: string) {
    this.SET_CLIENT_ID(username + '-web-client')
    let c = mqtt.connect(this.url, this.config)
    this.SET_CLIENT(c)
    c.on('error', (err: Error) => {
      console.error(err)
      Message({
        message: '已成功连接mqtt服务器!',
        type: 'error'
      })
    })
    c.on('connect', () => {
      Message({
        message: '已成功连接mqtt服务器!',
        type: 'success'
      })

      c.subscribe('sensor_data', (err) => {
        if (!err) {
          Message({
            message: '已成功订阅主题!',
            type: 'success'
          })
        } else {
          Message({
            message: '订阅主题失败！',
            type: 'error'
          })
        }
      })

      c.on('message', (topic, payload) => {
        if (topic === 'sensor_data') {
          let recv = JSON.parse(payload.toString())
          if (recv.fire === true) {

          }
          if (recv.illumination === true) {

          }
          if (recv.solid === true) {

          }
        }
      })
    })
  }
}

export const MqttModule = getModule(Mqtt)
