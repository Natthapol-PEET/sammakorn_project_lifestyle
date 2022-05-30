from pydantic import BaseModel


class ChangePassword(BaseModel):
    username: str
    old_pass: str
    new_pass: str


class ResetPassword(BaseModel):
    email: str



class ConfirmPassword(BaseModel):
    key: str
    new_pass: str
    confirm_pass: str
    