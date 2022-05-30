from pydantic import BaseModel

class CreateHome(BaseModel):
    home_name: str
    home_number: str


class UpdateHome(BaseModel):
    home_id: int
    home_name: str
    home_number: str
    stamp_count: int


class DeleteHome(BaseModel):
    home_id: int

