from pydantic import BaseModel
from datetime import datetime
from app.schemas.user import User

class PrescriptionBase(BaseModel):
    prescription_date: datetime = datetime.utcnow()
    medication: str
    dosage: str

class PrescriptionCreate(PrescriptionBase):
    patient_id: int
    prescriber_id: int

class Prescription(PrescriptionBase):
    id: int
    patient: User
    prescriber: User

    class Config:
        orm_mode = True
