from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import Appointment

router = APIRouter(prefix="/reports", tags=["reports"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/financial")
def financial_report(db: Session = Depends(get_db)):
    total = db.query(Appointment).filter(Appointment.status == "completed").count()
    return {"completed_appointments": total}
