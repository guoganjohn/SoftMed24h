from pydantic import BaseModel
from datetime import datetime
from app.schemas.user import User

class MedicalRecordBase(BaseModel):
    record_date: datetime = datetime.utcnow()
    diagnosis: str
    treatment: str

class MedicalRecordCreate(MedicalRecordBase):
    patient_id: int

class MedicalRecord(MedicalRecordBase):
    id: int
    patient: User

    class Config:
        orm_mode = True
