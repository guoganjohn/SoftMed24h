from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database import Base
from app.models.user import User
from datetime import datetime

class Prescription(Base):
    __tablename__ = "prescriptions"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("users.id"))
    prescriber_id = Column(Integer, ForeignKey("users.id"))
    prescription_date = Column(DateTime, default=datetime.utcnow)
    medication = Column(String)
    dosage = Column(String)

    patient = relationship("User", foreign_keys=[patient_id])
    prescriber = relationship("User", foreign_keys=[prescriber_id])
