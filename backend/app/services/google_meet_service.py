import os
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from dotenv import load_dotenv

load_dotenv()

class GoogleMeetService:
    def __init__(self):
        # This is a simplified example. In a real application, you would
        # handle the OAuth2 flow to get the user's consent and tokens.
        # For this example, we'll assume you have a token file.
        # You can get one by running the Google Calendar API quickstart.
        token_info = {
            "token": os.getenv("GOOGLE_OAUTH_TOKEN"),
            "refresh_token": os.getenv("GOOGLE_REFRESH_TOKEN"),
            "token_uri": "https://oauth2.googleapis.com/token",
            "client_id": os.getenv("GOOGLE_CLIENT_ID"),
            "client_secret": os.getenv("GOOGLE_CLIENT_SECRET"),
            "scopes": ["https://www.googleapis.com/auth/calendar.events"],
        }
        self.creds = Credentials.from_authorized_user_info(token_info)
        self.service = build('calendar', 'v3', credentials=self.creds)

    def create_meeting(self, summary, start_time, end_time, attendees):
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
        event = self.service.events().insert(calendarId='primary', body=event, conferenceDataVersion=1).execute()
        return event.get('hangoutLink')
