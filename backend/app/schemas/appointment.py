from pydantic import BaseModel
from datetime import datetime
from app.schemas.user import User

class AppointmentBase(BaseModel):
    appointment_time: datetime
    status: str = "scheduled"

class AppointmentCreate(AppointmentBase):
    patient_id: int
    doctor_id: int

class Appointment(AppointmentBase):
    id: int
    patient: User
    doctor: User

    class Config:
        orm_mode = True
