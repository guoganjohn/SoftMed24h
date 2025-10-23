from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import appointments, auth, queue, medical_records, prescriptions, reports, payments, users
from app.database import engine
from app.models import user, appointment, medical_record, prescription

user.Base.metadata.create_all(bind=engine) # NOTE: In a production environment, consider using Alembic for database migrations.

app = FastAPI()

# Configure CORS
origins = [
    "*"  # Allow all origins for development. Restrict this in production!
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(appointments.router)
app.include_router(queue.router)
app.include_router(medical_records.router)
app.include_router(prescriptions.router)
app.include_router(reports.router)
app.include_router(payments.router)
app.include_router(users.router)
