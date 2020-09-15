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
      <el-button
        class="filter-item"
        type="primary"
        icon="el-icon-plus"
        @click="handleCreate"
      >
        添加权限
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

      <el-table-column
        label="权限"
      >
        <template slot-scope="{row}">
          {{ row.name }}
        </template>
      </el-table-column>
      <el-table-column
        v-if="isAdmin"
        label="操作"
        align="center"
        width="230"
        class-name="fixed-width"
      >
        <template slot-scope="{row, $index}">
          <el-button
            type="primary"
            size="mini"
            @click="handleUpdate(row)"
          >
            {{ '编辑' }}
          </el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(row, $index)"
          >
            {{ '删除' }}
          </el-button>
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

    <el-dialog
      :title="textMap[dialogStatus]"
      :visible.sync="dialogFormVisible"
    >
      <el-form
        ref="dataForm"
        :rules="rules"
        :model="tempRoleData"
        label-position="left"
        label-width="100px"
        style="width: 400px; margin-left:50px;"
      >
        <el-form-item
          label="权限名"
          prop="name"
        >
          <el-input v-model="tempRoleData.name" />
        </el-form-item>
      </el-form>
      <div
        slot="footer"
        class="dialog-footer"
      >
        <el-button @click="dialogFormVisible = false">
          {{ '取消' }}
        </el-button>
        <el-button
          type="primary"
          @click="dialogStatus==='create'?createData():updateData()"
        >
          {{ '确认' }}
        </el-button>
      </div>
    </el-dialog>
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
import { IHardwareData, IRoleData, IUserData } from '@/api/types'
import { UserModule } from '@/store/modules/user'
import {
  createRole,
  defaultRoleData,
  defaultUserData,
  deleteRole,
  getRolesData,
  getUserData,
  updateRole
} from '@/api/user'
import da from "element-ui/src/locale/lang/da";

  @Component({
    name: 'UserTable',
    components: {
      Pagination
    }
  })
export default class extends Vue {
    private total = 0
    private list: IRoleData[] = []
    private listLoading = true
    private listQuery = {
      page: 1,
      size: 20,
      query: ''
    }
    private downloadLoading = false
    private isAdmin = UserModule.roles.includes('admin')

    private rules = {
      name: [{ required: true, message: 'name is required', trigger: 'change' }],
      roles: [{ required: true, message: 'roles is required', trigger: 'change' }]
    }

    private dialogStatus = ''
    private textMap = {
      update: 'Edit',
      create: 'Create'
    }
    private dialogFormVisible = false
    private tempRoleData = defaultRoleData

    created() {
      this.getList()
    }

    private async getList() {
      this.listLoading = true
      const { data } = await getRolesData(this.listQuery)
      console.log(data)
      this.list = data.list
      this.total = data.total
      this.listLoading = false
    }

    private handleUpdate(row: any) {
      this.tempRoleData = Object.assign({}, row)
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        (this.$refs.dataForm as Form).clearValidate()
      })
    }

    private handleFilter() {
      console.log(this.listQuery)
      this.listQuery.page = 1
      this.getList()
    }

    private resetTempUserData() {
      this.tempRoleData = cloneDeep(defaultRoleData)
    }

    private handleCreate() {
      this.resetTempUserData()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        (this.$refs.dataForm as Form).clearValidate()
      })
    }

    private createData() {
      (this.$refs.dataForm as Form).validate(async(valid) => {
        if (valid) {
          const tempRoleData = this.tempRoleData
          const { data } = await createRole(tempRoleData)
          this.list.unshift(data)
          this.dialogFormVisible = false
          this.$notify({
            title: '成功',
            message: '创建成功',
            type: 'success',
            duration: 2000
          })
        }
      })
    }

    private updateData() {
      (this.$refs.dataForm as Form).validate(async(valid) => {
        if (valid) {
          const tempData = Object.assign({}, this.tempRoleData)
          const { data } = await updateRole(tempData.id, tempData)
          console.log(data)
          const index = this.list.findIndex(v => v.id === data.id)
          this.list.splice(index, 1, data)
          this.dialogFormVisible = false
          this.$notify({
            title: '成功',
            message: '更新成功',
            type: 'success',
            duration: 2000
          })
        }
      })
    }

    private handleDelete(row: any, index: number) {
      this.$alert('请确认是否删除', '确认删除', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async() => {
        const tempData = Object.assign({}, this.tempRoleData)
        await deleteRole(tempData.id)
        this.$notify({
          title: '成功',
          message: '成功删除',
          type: 'success',
          duration: 2000
        })
        this.list.splice(index, 1)
      })
    }

    private handleDownload() {
      this.downloadLoading = true
      const tHeader = ['id', '权限名']
      const filterVal = ['id', 'name']
      const data = formatJson(filterVal, this.list)
      exportJson2Excel(tHeader, data, '权限信息')
      this.downloadLoading = false
    }
}
</script>
<style lang="scss" scoped>
  .filter-container {
    margin-bottom: 20px;
  }
</style>
