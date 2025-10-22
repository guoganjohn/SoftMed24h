from app.schemas.appointment import AppointmentCreate, AppointmentResponse
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class AppointmentCreate(BaseModel):
    patient_id: str

class AppointmentResponse(BaseModel):
    id: str
    queue_position: int
    status: str
    meet_link: Optional[str]
    scheduled_at: datetime

    class Config:
        orm_mode = True
