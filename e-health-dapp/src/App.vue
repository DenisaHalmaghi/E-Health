<template>
  <v-app dark full-height full-width>
    <Header />
    <Suspense>
      <RouterView />
    </Suspense>
  </v-app>
</template>

<script lang="ts" setup>
import { RouterLink, RouterView } from "vue-router";
import Header from "./components/common/Header.vue";
import useAuthStore from "./stores/auth-store";

// const authStore = useAuthStore();
// await authStore.auth();

// const address =
</script>
