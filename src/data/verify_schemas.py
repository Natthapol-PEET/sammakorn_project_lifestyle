from pydantic import BaseModel


class VerifySchemas(BaseModel):
    username: str
    password: str