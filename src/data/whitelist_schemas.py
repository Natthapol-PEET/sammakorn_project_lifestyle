from pydantic import BaseModel


class UpdateWhitelist(BaseModel):
    whitelist_id: int
    home_id: int
    Class: str
    class_id: int
    firstname: str
    lastname: str
    resident_add_reason: str
    license_plate: str
    qr_gen_id: str
    id_card: str
    email: str

class DeleteWhitelist(BaseModel):
    whitelist_id: int