<template>
  <div class="dashboard-editor-container">
    <panel-group :group-data="panelData" />

    <el-row style="background:#fff;padding:16px 16px 0;margin-bottom:32px;">
      <line-chart :chart-data="lineChartData" />
    </el-row>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import { UserModule } from '@/store/modules/user'
import LineChart from '@/views/dashboard/components/LineChart.vue'
// @ts-ignore
import PanelGroup, { IPanelGroupData } from '@/views/dashboard/components/PanelGroup.vue'

const panelGroupData: IPanelGroupData[] = [
  {
    icon: 'hardware',
    name: '总硬件数',
    startValue: 0,
    endValue: 0,
    duration: 1
  },
  {
    icon: 'user',
    name: '总用户数',
    startValue: 0,
    endValue: 0,
    duration: 1
  },
  {
    icon: '在线',
    name: '',
    startValue: 0,
    endValue: 0,
    duration: 1
  },
  {
    icon: '',
    name: '',
    startValue: 0,
    endValue: 0,
    duration: 1
  }
]

  @Component({
    name: 'DashboardAdmin',
    components: {
      PanelGroup,
      LineChart
    }
  })
export default class extends Vue {
  get name() {
    return UserModule.name
  }

  get roles() {
    return UserModule.roles
  }

  get panelData() {
    return panelGroupData
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
