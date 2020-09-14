<template>
  <div class="dashboard-container">
    <component :is="currentRole" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import { UserModule } from '@/store/modules/user'
import AdminDashboard from './admin/index.vue'
import ManagerDashboard from './manager/index.vue'

  @Component({
    name: 'Dashboard',
    components: {
      AdminDashboard,
      ManagerDashboard
    }
  })
export default class extends Vue {
    private currentRole = 'admin-dashboard'

    get roles() {
      return UserModule.roles
    }

    created() {
      if (!this.roles.includes('admin')) {
        this.currentRole = 'manager-dashboard'
      }
    }
}
</script>
