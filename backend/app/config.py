from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str
    SECRET_KEY: str
    GOOGLE_CLIENT_ID: str
    GOOGLE_CLIENT_SECRET: str
    MEMED_API_KEY: str
    STRIPE_SECRET_KEY: str

    class Config:
        env_file = ".env"

settings = Settings()
