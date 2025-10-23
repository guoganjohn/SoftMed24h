from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from app.services.queue_service import QueueService

router = APIRouter()

@router.post("/queue/add/{patient_id}")
def add_to_queue(patient_id: int, queue_service: QueueService = Depends()):
    try:
        queue_service.add_to_queue(patient_id)
        return {"message": f"Patient {patient_id} added to the queue."}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to add patient to queue: {e}"
        )

@router.delete("/queue/remove/{patient_id}")
def remove_from_queue(patient_id: int, queue_service: QueueService = Depends()):
    try:
        queue_service.remove_from_queue(patient_id)
        return {"message": f"Patient {patient_id} removed from the queue."}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to remove patient from queue: {e}"
        )

@router.get("/queue", response_model=List[int])
def get_queue(queue_service: QueueService = Depends()):
    try:
        return queue_service.get_queue()
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve queue: {e}"
        )