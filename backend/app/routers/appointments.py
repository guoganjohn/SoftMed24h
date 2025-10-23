from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.appointment import Appointment as AppointmentModel
from app.schemas.appointment import Appointment as AppointmentSchema
from app.services.google_meet_service import GoogleMeetService
from datetime import datetime, timedelta

router = APIRouter()

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/appointments", response_model=List[AppointmentSchema])
def get_appointments(db: Session = Depends(get_db)):
    appointments = db.query(AppointmentModel).all()
    return appointments

@router.post("/create-meeting")
def create_meeting(meet_service: GoogleMeetService = Depends()):
    summary = "Test Meeting"
    start_time = datetime.utcnow() + timedelta(hours=1)
    end_time = start_time + timedelta(hours=1)
    attendees = ["test@example.com"]
    meet_link = meet_service.create_meeting(summary, start_time, end_time, attendees)
    return {"meet_link": meet_link}
