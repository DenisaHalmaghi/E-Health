export interface Medication {
  name: string;
  dose: string;
  frequency: string;
  duration: string;
}

export interface Prescription {
  diagnostic: string;
  medications: Medication[];
  oneTimeUsage: boolean;
}

export interface Consultation {
  patient: string;
  prescription: Prescription;
}
