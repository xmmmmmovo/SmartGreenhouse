<template>
  <div class="dashboard-editor-container">
    <panel-group :group-data="panelGroupData" />

    <el-row style="background:#fff;padding:16px 16px 0;margin-bottom:32px;">
      <el-select
        v-model="uuid"
        style="width: 140px"
        class="filter-item"
        filterable
        clearable
        @change="handleFilter"
      >
        <el-option
          v-for="item in hardwareList"
          :key="item.uuid"
          :label="item.name"
          :value="item.uuid"
        />
      </el-select>
      <line-chart :chart-data="lineChartData" />
    </el-row>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import { UserModule } from '@/store/modules/user'
// @ts-ignore
import LineChart, { ILineChartData } from '@/views/dashboard/components/LineChart.vue'
// @ts-ignore
import PanelGroup, { IPanelGroupData } from '@/views/dashboard/components/PanelGroup.vue'
import { IHardwareData, ISensorData } from '@/api/types'
import { getHardwareList } from '@/api/hardware'
import { getRolesData } from '@/api/user'
import { getDailySensorData } from '@/api/sensor'
import { parseTime } from '@/utils'
// eslint-disable-next-line no-undef
import Timer = NodeJS.Timer;

  @Component({
    name: 'DashboardAdmin',
    components: {
      PanelGroup,
      LineChart
    }
  })
export default class extends Vue {
    private hardwareList: IHardwareData[] = []
    private uuid: string = ''

    private lineChartData: ILineChartData = {
      temperatureData: [0],
      humidityData: [0],
      timeData: ['0']
    }

    private timer: Timer= setInterval(() => {
      this.getChartData()
    }, 70000);

    private panelGroupData: IPanelGroupData[] = [
      {
        icon: 'hardware',
        name: '总硬件数',
        startValue: 0,
        endValue: 0,
        duration: 1
      },
      {
        icon: 'manage',
        name: '在线设备数',
        startValue: 0,
        endValue: 0,
        duration: 1
      }
    ]

    get name() {
      return UserModule.name
    }

    get roles() {
      return UserModule.roles
    }

    private async getChartData() {
      const { data } = await getDailySensorData({ 'uuid': this.uuid })
      const tempData: ISensorData[] = data
      const temp:ILineChartData = {
        temperatureData: [],
        humidityData: [],
        timeData: []
      }
      if (tempData.length > 0) {
        tempData.forEach(value => {
          temp.temperatureData.push(value.temperature)
          temp.humidityData.push(value.humidity)
          // @ts-ignore
          temp.timeData.push(parseTime(value.record_time))
        })
      } else {
        temp.temperatureData.push(0)
        temp.humidityData.push(0)
        temp.timeData.push('0')
      }
      this.lineChartData = temp
    }

    created() {
      this.getList()
    }

    beforeDestroy() {
      clearInterval(this.timer)
    }

    private handleFilter() {
      this.getChartData()
    }

    private async getList() {
      const { data } = await getHardwareList(null)
      console.log(data)
      this.hardwareList = data.list
      this.panelGroupData[0].endValue = this.hardwareList.length
      this.panelGroupData[1].endValue = this.hardwareList.filter(value => { return value.up }).length
    }
}
</script>

<style lang="scss" scoped>
  .dashboard-editor-container {
    padding: 32px;
    background-color: rgb(240, 242, 245);
    position: relative;

    .github-corner {
      position: absolute;
      top: 0px;
      border: 0;
      right: 0;
    }

    .chart-wrapper {
      background: #fff;
      padding: 16px 16px 0;
      margin-bottom: 32px;
    }
  }

  @media (max-width:1024px) {
    .chart-wrapper {
      padding: 8px;
    }
  }
</style>
