from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime, date

class UserBase(BaseModel):
    email: str
    name: Optional[str] = None
    gender: Optional[str] = None
    cpf: Optional[str] = None
    phone: Optional[str] = None
    birthday: Optional[date] = None
    cep: Optional[str] = None

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
        from_attributes = True

# Import after User is defined to avoid circular import
from app.schemas.medical_record import MedicalRecord
from app.schemas.prescription import Prescription

User.update_forward_refs()