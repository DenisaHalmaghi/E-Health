<template>
  <v-switch
    v-model="prescription.oneTimeUsage"
    label="One Time Usage"
    color="primary"
  ></v-switch>
  <v-text-field
    label="Diagnostic"
    v-model="prescription.diagnostic"
  ></v-text-field>
  <template
    v-for="(medication, index) in prescription.medications"
    :key="index"
  >
    <v-text-field
      :label="'Medication ' + (index + 1)"
      v-model="medication.name"
    ></v-text-field>
    <v-text-field
      :label="'Dose ' + (index + 1)"
      v-model="medication.dose"
    ></v-text-field>
    <v-text-field
      :label="'Frequency ' + (index + 1)"
      v-model="medication.frequency"
    ></v-text-field>
    <v-text-field label="Duration" v-model="medication.duration"></v-text-field>
  </template>
  <v-btn color="primary" @click="addMedication">Add New Medication</v-btn>
</template>

<script lang="ts" setup>
import type { Prescription } from "@/types/consultation";
import { reactive, watch } from "vue";

const prescription: Prescription = reactive({
  diagnostic: "",
  oneTimeUsage: false,
  medications: [{ name: "", dose: "", frequency: "", duration: "" }],
});

const emit = defineEmits(["update:prescription"]);

watch([prescription], () => {
  emit("update:prescription", prescription);
});

const addMedication = () => {
  prescription.medications.push({
    name: "",
    dose: "",
    frequency: "",
    duration: "",
  });
};
</script>
