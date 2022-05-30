from pydantic import BaseModel


class RecoverySchemas(BaseModel):
    email: str
    url: str = "http://domain.com/"


class ConfirmSchemas(BaseModel):
    key: str
    new_password: str
