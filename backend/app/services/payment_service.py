import os
import stripe
from dotenv import load_dotenv

load_dotenv()

class PaymentService:
    def __init__(self):
        self.api_key = os.getenv("STRIPE_SECRET_KEY")
        stripe.api_key = self.api_key

    def create_payment_intent(self, amount: int, currency: str = "brl"):
        try:
            intent = stripe.PaymentIntent.create(
                amount=amount,
                currency=currency,
                automatic_payment_methods={"enabled": True},
            )
            return {"client_secret": intent.client_secret}
        except Exception as e:
            return {"error": str(e)}
