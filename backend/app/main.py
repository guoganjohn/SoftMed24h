from fastapi import FastAPI
from app.routers import appointments, auth, queue, medical_records, prescriptions, reports, payments, users
from app.database import engine
from app.models import user, appointment, medical_record, prescription

user.Base.metadata.create_all(bind=engine) # NOTE: In a production environment, consider using Alembic for database migrations.

app = FastAPI(title="SoftMed24h Backend")

app.include_router(auth.router)
app.include_router(appointments.router)
app.include_router(queue.router)
app.include_router(medical_records.router)
app.include_router(prescriptions.router)
app.include_router(reports.router)
app.include_router(payments.router)
app.include_router(users.router)
