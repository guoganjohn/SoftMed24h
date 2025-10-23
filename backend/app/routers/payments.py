from fastapi import APIRouter, Depends, HTTPException, status
from app.services.payment_service import PaymentService

router = APIRouter()

from app.schemas.payments import CreatePaymentIntentRequest, PaymentIntentResponse

@router.post("/create-payment-intent", response_model=PaymentIntentResponse)
def create_payment_intent(request: CreatePaymentIntentRequest, payment_service: PaymentService = Depends()):
    try:
        response = payment_service.create_payment_intent(request.amount)
        if "error" in response:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=response["error"]
            )
        return response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create payment intent: {e}"
        )