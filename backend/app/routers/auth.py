from fastapi import APIRouter

router = APIRouter()

@router.post("/token")
def login():
    return {"message": "This is the auth router for token generation."}
