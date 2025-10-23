from sqlalchemy import Boolean, Column, Integer, String, Date
from datetime import date
from sqlalchemy.orm import relationship
from app.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)

    # New fields
    name = Column(String, index=True)
    gender = Column(String)
    cpf = Column(String, unique=True, index=True)
    phone = Column(String)
    birthday = Column(Date)
    cep = Column(String)

    medical_records = relationship("MedicalRecord", back_populates="patient")
    prescriptions = relationship("Prescription", foreign_keys="[Prescription.patient_id]", back_populates="patient")
    appointments_as_patient = relationship("Appointment", foreign_keys="[Appointment.patient_id]", back_populates="patient")
    appointments_as_doctor = relationship("Appointment", foreign_keys="[Appointment.doctor_id]", back_populates="doctor")
    prescriptions_as_prescriber = relationship("Prescription", foreign_keys="[Prescription.prescriber_id]", back_populates="prescriber")
