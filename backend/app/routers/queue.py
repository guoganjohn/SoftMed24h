from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app import models

router = APIRouter(prefix="/queue", tags=["queue"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/status/{patient_id}")
def get_queue_position(patient_id: str, db: Session = Depends(get_db)):
    appt = db.query(models.Appointment).filter_by(patient_id=patient_id, status="waiting").first()
    if not appt:
        return {"message": "No active queue"}
    position = db.query(models.Appointment).filter(
        models.Appointment.status == "waiting",
        models.Appointment.queue_position <= appt.queue_position
    ).count()
    return {"position": position}

@router.post("/next")
def call_next_patient(db: Session = Depends(get_db)):
    next_appt = db.query(models.Appointment).filter_by(status="waiting").order_by(models.Appointment.queue_position).first()
    if not next_appt:
        return {"message": "No patients in queue"}
    next_appt.status = "in_progress"
    db.commit()
    return {"next_patient_id": next_appt.patient_id}
