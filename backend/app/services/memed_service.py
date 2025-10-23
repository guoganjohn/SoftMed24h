import os
import httpx
from dotenv import load_dotenv

load_dotenv()

class MemedService:
    def __init__(self):
        self.api_key = os.getenv("MEMED_API_KEY")
        self.base_url = "https://api.memed.com.br/v1"
        self.token = self._get_token()

    def _get_token(self):
        # This is a simplified example. In a real application, you would
        # handle token expiration and renewal.
        headers = {
            "Content-Type": "application/x-www-form-urlencoded",
        }
        data = {
            "grant_type": "client_credentials",
            "client_id": "memed",
            "client_secret": self.api_key,
        }
        response = httpx.post(f"{self.base_url}/auth/token", headers=headers, data=data)
        response.raise_for_status()
        return response.json()["access_token"]

    def create_prescription(self, patient_name, medicines):
        headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json",
        }
        data = {
            "patient": {"name": patient_name},
            "medicines": medicines,
        }
        response = httpx.post(f"{self.base_url}/prescricao", headers=headers, json=data)
        response.raise_for_status()
        return response.json()
