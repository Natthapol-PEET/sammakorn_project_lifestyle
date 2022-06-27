from pydantic import BaseModel


class RegisterWalkin(BaseModel):
    code: str
    idCard: str
    home_number: str
    licensePlate: str
    guardId: str