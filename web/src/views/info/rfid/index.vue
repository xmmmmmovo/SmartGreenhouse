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
        value-format="yyyy-MM-dd HH:mm:ss"
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
        label="使用用户"
        min-width="120px"
      >
        <template slot-scope="{row}">
          {{ row.username }}
        </template>
      </el-table-column>

      <el-table-column
        label="uuid"
        min-width="120px"
      >
        <template slot-scope="{row}">
          {{ row.hardware_uuid }}
        </template>
      </el-table-column>

      <el-table-column
        label="客户端名称"
        min-width="120px"
      >
        <template slot-scope="{row}">
          {{ row.name }}
        </template>
      </el-table-column>
      <el-table-column
        label="记录时间"
        class-name="status-col"
        width="100"
      >
        <template slot-scope="{row}">
          {{ row.log_time }}
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
import { IRFIDData } from '@/api/types'
import { getRFIDData } from '@/api/rfid'

  @Component({
    name: 'RFIDTable',
    components: {
      Pagination
    }
  })
export default class extends Vue {
    private total = 0
    private list: IRFIDData[] = []
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
      { label: 'username' },
      { label: 'hardware_uuid' },
      { label: 'name' }
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
      const { data } = await getRFIDData(this.listQuery)
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
      const tHeader = ['uuid', '使用用户', '记录时间', '客户端名称']
      const filterVal = ['hardware_uuid', 'username', 'log_time', 'name']
      const data = formatJson(filterVal, this.list)
      exportJson2Excel(tHeader, data, 'RFID信息')
      this.downloadLoading = false
    }
}
</script>
<style lang="scss" scoped>
  .filter-container {
    margin-bottom: 20px;
  }
</style>
