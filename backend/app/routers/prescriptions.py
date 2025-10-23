from fastapi import APIRouter, Depends
from app.services.memed_service import MemedService

router = APIRouter()

@router.post("/create-prescription")
def create_prescription(memed_service: MemedService = Depends()):
    patient_name = "John Doe"
    medicines = [
        {
            "id": 123, # Example medicine ID
            "posology": "1 pill per day"
        }
    ]
    prescription = memed_service.create_prescription(patient_name, medicines)
    return prescription