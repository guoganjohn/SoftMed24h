import os
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from datetime import datetime
from typing import List
from dotenv import load_dotenv

load_dotenv()

class GoogleMeetService:
    def __init__(self):
        # This is a simplified example. In a real application, you would
        # handle the OAuth2 flow to get the user's consent and tokens.
        # For this example, we'll assume you have a token file.
        # You can get one by running the Google Calendar API quickstart.
        google_oauth_token = os.getenv("GOOGLE_OAUTH_TOKEN")
        google_refresh_token = os.getenv("GOOGLE_REFRESH_TOKEN")
        google_client_id = os.getenv("GOOGLE_CLIENT_ID")
        google_client_secret = os.getenv("GOOGLE_CLIENT_SECRET")

        if not all([google_oauth_token, google_refresh_token, google_client_id, google_client_secret]):
            raise Exception("Missing Google API credentials in environment variables.")

        token_info = {
            "token": google_oauth_token,
            "refresh_token": google_refresh_token,
            "token_uri": "https://oauth2.googleapis.com/token",
            "client_id": google_client_id,
            "client_secret": google_client_secret,
            "scopes": ["https://www.googleapis.com/auth/calendar.events"],
        }
        self.creds = Credentials.from_authorized_user_info(token_info)
        self.service = build('calendar', 'v3', credentials=self.creds)

    def create_meeting(self, summary: str, start_time: datetime, end_time: datetime, attendees: List[str]):
        event = {
            'summary': summary,
            'start': {
                'dateTime': start_time.isoformat(),
                'timeZone': 'America/Sao_Paulo',
            },
            'end': {
                'dateTime': end_time.isoformat(),
                'timeZone': 'America/Sao_Paulo',
            },
            'attendees': [{'email': email} for email in attendees],
            'conferenceData': {
                'createRequest': {
                    'requestId': 'sample-request',
                    'conferenceSolutionKey': {
                        'type': 'hangoutsMeet'
                    }
                }
            }
        }
        try:
            event = self.service.events().insert(calendarId='primary', body=event, conferenceDataVersion=1).execute()
            return event.get('hangoutLink')
        except Exception as e:
            raise Exception(f"Failed to create Google Meet event: {e}")
