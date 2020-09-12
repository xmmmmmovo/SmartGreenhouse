import Vue from 'vue'
import Vuex from 'vuex'
import { IAppState } from './modules/app'
import { IUserState } from './modules/user'
import { IMqttState } from './modules/mqtt'

Vue.use(Vuex)

export interface IRootState {
  app: IAppState
  user: IUserState
  mqtt: IMqttState
}

// Declare empty store first, dynamically register all modules later.
export default new Vuex.Store<IRootState>({})
