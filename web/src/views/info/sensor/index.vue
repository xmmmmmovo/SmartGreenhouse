<template>
  <div class="app-container">
    <div class="filter-container">
      <el-input
        v-model="listQuery.query"
        placeholder="关键词"
        style="width: 200px;"
        class="filter-item"
        @keyup.enter.native="handleFilter"
      />
      <el-select
        v-model="listQuery.type"
        placeholder="类型"
        class="filter-item"
        style="width: 130px"
      >
        <el-option
          v-for="item in typeOptions"
          :key="item.label"
          :label="item.label"
          :value="item.label"
        />
      </el-select>
      <el-select
        v-model="listQuery.ordered"
        style="width: 140px"
        class="filter-item"
        @change="handleFilter"
      >
        <el-option
          v-for="item in sortOptions"
          :key="item.key"
          :label="item.label"
          :value="item.key"
        />
      </el-select>
      <el-date-picker
        v-model="listQuery.date"
        type="datetimerange"
        :picker-options="pickerOptions"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        align="right"
      />
      <el-button
        class="filter-item"
        type="primary"
        icon="el-icon-search"
        @click="handleFilter"
      >
        搜索
      </el-button>
      <el-button
        :loading="downloadLoading"
        class="filter-item"
        type="primary"
        icon="el-icon-download"
        @click="handleDownload"
      >
        导出
      </el-button>
    </div>

    <el-table
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      style="width: 100%;"
    >
      <el-table-column
        label="id"
        prop="id"
        align="center"
        width="80"
      >
        <template slot-scope="{$index}">
          <span>{{ (listQuery.ordered[0] === '+') ? $index + 1 : total - $index }}</span>
        </template>
      </el-table-column>

      <el-table-column
        label="名称"
        min-width="65px"
      >
        <template slot-scope="{row}">
          {{ row.name }}
        </template>
      </el-table-column>

      <el-table-column
        label="uuid"
        min-width="120px"
      >
        <template slot-scope="{row}">
          {{ row.uuid }}
        </template>
      </el-table-column>

      <el-table-column
        label="温度阈值"
      >
        <template slot-scope="{row}">
          {{ row.temperature_limit }}
        </template>
      </el-table-column>

      <el-table-column
        label="湿度阈值"
      >
        <template slot-scope="{row}">
          {{ row.humidity_limit }}
        </template>
      </el-table-column>
      <el-table-column
        label="是否在线"
        class-name="status-col"
        width="100"
      >
        <template slot-scope="{row}">
          <el-tag :type="row.up ? 'success' : 'info'">
            {{ row.up ? '在线': '已下线' }}
          </el-tag>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="listQuery.page"
      :limit.sync="listQuery.size"
      @pagination="getList"
    />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import { Form } from 'element-ui'
import { cloneDeep } from 'lodash'
import { exportJson2Excel } from '@/utils/excel'
import { formatJson } from '@/utils'
import Pagination from '@/components/Pagination/index.vue'
import { defaultHardwareData, deleteHardwareData, getHardwareList, updateHardwareData } from '@/api/hardware'
import { ISensorData } from '@/api/types'

  @Component({
    name: 'SensorTable',
    components: {
      Pagination
    }
  })
export default class extends Vue {
    private total = 0
    private list: ISensorData[] = []
    private listLoading = true
    private listQuery = {
      page: 1,
      size: 20,
      ordered: '+',
      query: '',
      type: 'id',
      date: []
    }
    private sortOptions = [
      { label: 'Ascending', key: '+' },
      { label: 'Descending', key: '-' }
    ]
    private typeOptions = [
      { label: 'temperature' },
      { label: 'humidity' },
      { label: 'is_fire' },
      { label: 'is_dry' },
      { label: 'is_illum' },
      { label: 'hardware_uuid' },
      { label: 'id' }
    ]
    private downloadLoading = false

    private timevalue = ''
    private pickerOptions= {
      shortcuts: [{
        text: '最近一周',
        onClick(picker: any) {
          const end = new Date()
          const start = new Date()
          start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)
          picker.$emit('pick', [start, end])
        }
      }, {
        text: '最近一个月',
        onClick(picker: any) {
          const end = new Date()
          const start = new Date()
          start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
          picker.$emit('pick', [start, end])
        }
      }, {
        text: '最近三个月',
        onClick(picker: any) {
          const end = new Date()
          const start = new Date()
          start.setTime(start.getTime() - 3600 * 1000 * 24 * 90)
          picker.$emit('pick', [start, end])
        }
      }]
    }

    created() {
      this.getList()
    }

    private async getList() {
      this.listQuery.ordered = this.listQuery.ordered[0] + this.listQuery.type
      this.listLoading = true
      const { data } = await getHardwareList(this.listQuery)
      this.list = data.list
      this.total = data.total
      console.log(this.list)
      this.listLoading = false
    }

    private handleFilter() {
      console.log(this.listQuery)
      this.listQuery.page = 1
      this.getList()
    }

    private handleDownload() {
      this.downloadLoading = true
      const tHeader = ['名称', '是否在线', 'uuid', '温度阈值', '湿度阈值']
      const filterVal = ['name', 'up', 'uuid', 'temperature_limit', 'humidity_limit']
      const data = formatJson(filterVal, this.list)
      exportJson2Excel(tHeader, data, '硬件信息')
      this.downloadLoading = false
    }

    private cc() {
      console.log(this.timevalue)
    }
}
</script>
<style lang="scss" scoped>
  .filter-container {
    margin-bottom: 20px;
  }
</style>
