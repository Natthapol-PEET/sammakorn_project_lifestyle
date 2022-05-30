


from pydantic import BaseModel


class DeleteGuard(BaseModel):
    guard_id: int


class UpdateGuard(BaseModel):
    guard_id: int
    firstname: str
    lastname: str
    username: str
    email: str
    active_user: bool
    role: str
    id_card: str


class CreateGuard(BaseModel):
    firstname: str
    lastname: str
    username: str
    password: str
    email: str
    role: str
    id_card: str

