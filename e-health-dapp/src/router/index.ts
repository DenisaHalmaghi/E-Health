import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/consultations",
      name: "add-consultation",
      component: () => import("../views/AddConsultation.vue"),
    },
  ],
});

export default router;
