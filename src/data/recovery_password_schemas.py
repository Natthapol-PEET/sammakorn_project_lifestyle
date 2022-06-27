from pydantic import BaseModel


class RecoverySchemas(BaseModel):
    email: str


class ConfirmSchemas(BaseModel):
    key: str
    new_password: str
