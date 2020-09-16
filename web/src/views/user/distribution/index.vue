<template>
  <div class="app-container">
    <div class="filter-container">
      <el-select
        v-model="listQuery.userId"
        style="width: 140px"
        class="filter-item"
        filterable
        clearable
        @change="handleFilter"
      >
        <el-option
          v-for="item in userList"
          :key="item.id"
          :label="item.username"
          :value="item.id"
        />
      </el-select>
      <el-select
        v-model="listQuery.hardwareuuid"
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
        添加派发条目
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
        label="客户端名称"
      >
        <template slot-scope="{row}">
          {{ row.name }}
        </template>
      </el-table-column>
      <el-table-column
        label="uuid"
      >
        <template slot-scope="{row}">
          {{ row.uuid }}
        </template>
      </el-table-column>
      <el-table-column
        label="派发用户名"
      >
        <template slot-scope="{row}">
          {{ row.username }}
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
        :model="tempDistributeData"
        label-position="left"
        label-width="100px"
        style="width: 400px; margin-left:50px;"
      >
        <el-form-item
          label="用户名"
          prop="id"
        >
          <el-select
            v-model="tempDistributeData.id"
            style="width: 140px"
            class="filter-item"
            filterable
            clearable
          >
            <el-option
              v-for="item in userList"
              :key="item.id"
              :label="item.username"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item
          label="设备名"
          prop="uuid"
        >
          <el-select
            v-model="tempDistributeData.uuid"
            style="width: 140px"
            class="filter-item"
            filterable
            clearable
          >
            <el-option
              v-for="item in hardwareList"
              :key="item.uuid"
              :label="item.name"
              :value="item.uuid"
            />
          </el-select>
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
import { IHardwareData, IRoleData, IUserData } from '@/api/types'
import { UserModule } from '@/store/modules/user'
import {
  createRole,
  defaultRoleData,
  defaultUserData,
  deleteRole, getAllUser,
  getRolesData,
  getUserData,
  updateRole
} from '@/api/user'
import {
  createDistributeData,
  defaultDistributeData,
  deleteDistributeData,
  getAllHardware,
  getDistributeData, updateDistributeData
} from '@/api/hardware'

  @Component({
    name: 'DistributeTable',
    components: {
      Pagination
    }
  })
export default class extends Vue {
    private total = 0
    private list: IRoleData[] = []
    private userList: IUserData[] = []
    private hardwareList: IHardwareData[] = []
    private listLoading = true
    private listQuery = {
      page: 1,
      size: 20,
      userId: '',
      hardwareuuid: ''
    }
    private downloadLoading = false
    private isAdmin = UserModule.roles.includes('admin')

    private rules = {
      id: [{ required: true, message: 'id is required', trigger: 'change' }],
      uuid: [{ required: true, message: 'uuid is required', trigger: 'change' }]
    }

    private dialogStatus = ''
    private textMap = {
      update: 'Edit',
      create: 'Create'
    }
    private dialogFormVisible = false
    private tempDistributeData = defaultDistributeData

    created() {
      this.getList()
      this.getUserList()
      this.getHardwareList()
    }

    private async getList() {
      this.listLoading = true
      const { data } = await getDistributeData(this.listQuery)
      console.log(data)
      this.list = data.list
      this.total = data.total
      this.listLoading = false
    }

    private async getUserList() {
      this.listLoading = true
      const { data } = await getAllUser()
      console.log(data)
      this.userList = data
      this.listLoading = false
    }

    private async getHardwareList() {
      this.listLoading = true
      const { data } = await getAllHardware()
      console.log(data)
      this.hardwareList = data
      this.listLoading = false
    }

    private handleFilter() {
      console.log(this.listQuery)
      this.listQuery.page = 1
      this.getList()
    }

    private resetTempUserData() {
      this.tempDistributeData = cloneDeep(defaultDistributeData)
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
          const tempRoleData = this.tempDistributeData
          const { data } = await createDistributeData(tempRoleData)
          await this.getList()
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

    private handleDelete(row: any, index: number) {
      this.$alert('请确认是否删除', '确认删除', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async() => {
        const tempData = Object.assign({}, row)
        console.log(tempData)
        await deleteDistributeData(tempData.id)
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
      const tHeader = ['id', '客户端名称', 'uuid', '派发用户名']
      const filterVal = ['id', 'name', 'uuid', 'username']
      const data = formatJson(filterVal, this.list)
      exportJson2Excel(tHeader, data, '派发信息')
      this.downloadLoading = false
    }
}
</script>
<style lang="scss" scoped>
  .filter-container {
    margin-bottom: 20px;
  }
</style>
