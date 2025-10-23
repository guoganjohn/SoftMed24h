from typing import List
from fastapi import APIRouter, Depends
from app.services.queue_service import QueueService

router = APIRouter()

@router.post("/queue/add/{patient_id}")
def add_to_queue(patient_id: int, queue_service: QueueService = Depends()):
    queue_service.add_to_queue(patient_id)
    return {"message": f"Patient {patient_id} added to the queue."}

@router.delete("/queue/remove/{patient_id}")
def remove_from_queue(patient_id: int, queue_service: QueueService = Depends()):
    queue_service.remove_from_queue(patient_id)
    return {"message": f"Patient {patient_id} removed from the queue."}

@router.get("/queue", response_model=List[int])
def get_queue(queue_service: QueueService = Depends()):
    return queue_service.get_queue()