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
          <span>{{ $index + 1 }}</span>
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
import { getHardwareList } from '@/api/hardware'
import { IHardwareData } from '@/api/types'

  @Component({
    name: 'HardwareTable',
    components: {
      Pagination
    }
  })
export default class extends Vue {
  private total = 0
  private list: IHardwareData[] = []
  private listLoading = true
  private listQuery = {
    page: 1,
    size: 20,
    ordered: '+id',
    query: '',
    type: 'name'
  }
  private sortOptions = [
    { label: 'Ascending', key: '+' + this.listQuery.type },
    { label: 'Descending', key: '-' + this.listQuery.type }
  ]
  private typeOptions = [
    { label: 'humidity_limit' },
    { label: 'temperature_limit' },
    { label: 'name' },
    { label: 'uuid' }
  ]
  private downloadLoading = false

  created() {
    this.getList()
  }

  private async getList() {
    this.listLoading = true
    const { data } = await getHardwareList(this.listQuery)
    this.list = data.list
    this.total = data.total
    this.listLoading = false
  }

  private handleFilter() {
    console.log(this.listQuery)
    this.listQuery.page = 1
    this.getList()
  }

  private handleDownload() {
    this.downloadLoading = true
    const tHeader = ['timestamp', 'title', 'type', 'importance', 'status']
    const filterVal = ['timestamp', 'title', 'type', 'importance', 'status']
    const data = formatJson(filterVal, this.list)
    exportJson2Excel(tHeader, data, 'table-list')
    this.downloadLoading = false
  }
}
</script>
<style lang="scss">
</style>
