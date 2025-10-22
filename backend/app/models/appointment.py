from sqlalchemy import Column, String, Enum, Integer, ForeignKey, DateTime, Text
from sqlalchemy.dialects.postgresql import UUID
import uuid, enum
from datetime import datetime
from app.database import Base

class AppointmentStatus(enum.Enum):
    waiting = "waiting"
    in_progress = "in_progress"
    completed = "completed"
    technical_problem = "technical_problem"
    no_answer = "no_answer"

class Appointment(Base):
    __tablename__ = "appointments"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    patient_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    doctor_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    status = Column(Enum(AppointmentStatus), default=AppointmentStatus.waiting)
    queue_position = Column(Integer)
    meet_link = Column(Text)
    scheduled_at = Column(DateTime, default=datetime.utcnow)
    started_at = Column(DateTime)
    ended_at = Column(DateTime)
    payment_status = Column(Enum("pending", "paid", name="payment_status"), default="pending")
