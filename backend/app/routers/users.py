from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.user import User as UserModel # Explicitly import and alias User as UserModel
from app.schemas import user as user_schema
from passlib.context import CryptContext
from app.routers.auth import oauth2_scheme, SECRET_KEY, ALGORITHM # Import oauth2_scheme, SECRET_KEY, ALGORITHM
from jose import JWTError, jwt # Import jwt and JWTError

router = APIRouter()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password: str) -> str:
    """
    Hashes the password after ensuring it does not exceed the 72-character limit for bcrypt.
    """
    # Truncate the string to 72 characters if it's longer
    if len(password) > 72:
        password = password[:72]
    return pwd_context.hash(password)

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_user_by_email(db: Session, email: str):
    return db.query(UserModel).filter(UserModel.email == email).first()

# Dependency to get the current user from the JWT token
async def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> UserModel:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = get_user_by_email(db, email=email)
    if user is None:
        raise credentials_exception
    return user

@router.get("/users/me", response_model=user_schema.UserBaseInfo) # Use a specific schema to return limited info
def read_users_me(current_user: UserModel = Depends(get_current_user)):
    """
    Get the current logged-in user's information.
    """
    return {"name": current_user.name, "email": current_user.email, "id": current_user.id}

@router.post("/users/", response_model=user_schema.User)
def create_user(user: user_schema.UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(UserModel).filter(UserModel.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = get_password_hash(user.password)
    db_user = UserModel(
        email=user.email,
        hashed_password=hashed_password,
        name=user.name,
        gender=user.gender,
        cpf=user.cpf,
        phone=user.phone,
        birthday=user.birthday,
        cep=user.cep,
        logradouro=user.logradouro,
        numero=user.numero,
        complemento=user.complemento,
        bairro=user.bairro,
        estado=user.estado,
        cidade=user.cidade,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
