<template>
  <v-form>
    <v-text-field label="Patient" v-model="consultation.patient"></v-text-field>
    <v-switch
      v-model="needsPrescription"
      label="Prescription"
      color="primary"
    ></v-switch>

    <PrescriptionFields
      @update:prescription="updatePrescription"
      v-if="needsPrescription"
    />
    <v-switch
      v-model="needsReferral"
      label="Referral"
      color="primary"
    ></v-switch>
    <v-btn color="primary" @click="addConsultation">Finish Consultation</v-btn>
  </v-form>
</template>

<script lang="ts" setup>
import PrescriptionFields from "@/components/consultation/PrescriptionFields.vue";
import type { Consultation, Prescription } from "@/types/consultation";
import { reactive, ref } from "vue";
import EHealthService from "@/services/EHealthService";

const needsPrescription = ref(false);
const needsReferral = ref(false);

const service = new EHealthService();

const consultation: Consultation = reactive({
  patient: "",
  prescription: {} as Prescription,
});

// await service.getConsultations();
const updatePrescription = (prescription: Prescription) => {
  consultation.prescription = prescription;
};

const addConsultation = async () => {
  console.log("🚀 ~ file: AddConsultation.vue:38 ~ consultation", consultation);
  // Send the new prescription to the server here
  await service.createConsultation(consultation);
  console.log(consultation);
};
</script>
