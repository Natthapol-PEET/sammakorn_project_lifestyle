


from multiprocessing.dummy import active_children
from re import L
from pydantic import BaseModel


class DeleteAdmin(BaseModel):
    admin_id: int


class UpdateAdmin(BaseModel):
    admin_id: int
    firstname: str
    lastname: str
    username: str
    email: str
    role: str
    active_user: bool
    id_card: str
    

class CreateAdmin(BaseModel):
    firstname: str
    lastname: str
    username: str
    password: str
    email: str
    role: str
    id_card: str