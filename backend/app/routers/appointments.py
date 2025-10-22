from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app import models, schemas
from app.services.google_meet_service import create_meet_link

router = APIRouter(prefix="/appointments", tags=["appointments"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/purchase", response_model=schemas.AppointmentResponse)
def purchase_appointment(data: schemas.AppointmentCreate, db: Session = Depends(get_db)):
    count = db.query(models.Appointment).filter(models.Appointment.status == "waiting").count()
    new_appointment = models.Appointment(patient_id=data.patient_id, queue_position=count + 1)
    db.add(new_appointment)
    db.commit()
    db.refresh(new_appointment)
    return new_appointment

@router.post("/{appointment_id}/start-call")
def start_call(appointment_id: str, db: Session = Depends(get_db)):
    appointment = db.query(models.Appointment).get(appointment_id)
    if not appointment:
        raise HTTPException(status_code=404, detail="Appointment not found")

    meet_link = create_meet_link()  # integrate with Google Meet
    appointment.meet_link = meet_link
    appointment.status = "in_progress"
    db.commit()
    return {"meet_link": meet_link, "status": "in_progress"}
