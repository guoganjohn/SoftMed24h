from fastapi import APIRouter, Depends
from app.services.payment_service import PaymentService

router = APIRouter()

@router.post("/create-payment-intent")
def create_payment_intent(payment_service: PaymentService = Depends()):
    # Example amount in cents (e.g., R$ 50.00)
    amount = 5000
    return payment_service.create_payment_intent(amount)