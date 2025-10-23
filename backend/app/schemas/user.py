from typing import List
from pydantic import BaseModel, Field
from datetime import datetime

class UserBase(BaseModel):
    email: str

class UserCreate(UserBase):
    password: str = Field(..., max_length=72)

class UserLogin(BaseModel):
    email: str
    password: str

class User(UserBase):
    id: int
    is_active: bool
    medical_records: List["MedicalRecord"] = []
    prescriptions: List["Prescription"] = []

    class Config:
        orm_mode = True

# Import after User is defined to avoid circular import
from app.schemas.medical_record import MedicalRecord
from app.schemas.prescription import Prescription

User.update_forward_refs()