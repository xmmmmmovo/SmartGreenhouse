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
    })
  }
}

export const MqttModule = getModule(Mqtt)
