from pydantic import BaseModel


class RegisterWalkin(BaseModel):
    code: str
    idCard: str
    homeNumber: str
    licensePlate: str
    guardId: str