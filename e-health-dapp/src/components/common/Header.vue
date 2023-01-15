<template>
  <v-app-bar color="deep-purple" dense dark>
    <v-spacer></v-spacer>

    <v-btn v-for="item in routes" :key="item.title">
      <router-link :to="item.to">{{ item.title }}</router-link>
    </v-btn>

    <v-btn v-if="!signerAddress" @click="connectWallet">
      <v-icon large> mdi-wallet </v-icon>
    </v-btn>
    <template v-else>
      {{ signerAddress }}
    </template>
  </v-app-bar>
</template>

<script lang="ts" setup>
import useAuthStore from "@/stores/auth-store";
import { storeToRefs } from "pinia";
import { computed } from "vue";

const authStore = useAuthStore();
const { signerAddress } = storeToRefs(authStore);

console.log("🚀 ~ file: Header.vue:49 ~ authStore", signerAddress);

const connectWallet = async () => {
  if (!authStore.signer) {
    await authStore.auth();
    // console.log(
    //   "🚀 ~ file: Header.vue:49 ~ authStore",
    //   authStore.signerAddress
    // );
  }
};

const publicRoutes = [
  {
    title: "Home",
    to: "/",
  },
];

const authRoutes = [
  {
    title: "Consultations",
    to: "/consultations",
  },
];

const routes = computed(() => {
  const routesWithAuth = signerAddress.value ? authRoutes : [];
  return [...publicRoutes, ...routesWithAuth];
});
</script>

<style></style>
