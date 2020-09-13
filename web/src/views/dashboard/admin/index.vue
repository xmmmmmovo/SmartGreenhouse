<template>
  <div>
    Admin
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import { UserModule } from '@/store/modules/user'

  @Component({
    name: 'DashboardAdmin'
  })
export default class extends Vue {
    private emptyGif = 'https://wpimg.wallstcn.com/0e03b7da-db9e-4819-ba10-9016ddfdaed3'

    get name() {
      return UserModule.name
    }

    get roles() {
      return UserModule.roles
    }
}
</script>

<style lang="scss" scoped>
</style>
