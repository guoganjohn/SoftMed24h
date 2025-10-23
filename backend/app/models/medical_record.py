from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.user import User
from datetime import datetime

class MedicalRecord(Base):
    __tablename__ = "medical_records"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("users.id"))
    record_date = Column(DateTime, default=datetime.utcnow)
    diagnosis = Column(Text)
    treatment = Column(Text)

    patient = relationship("User")