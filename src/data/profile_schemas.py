from pydantic import BaseModel


class ProfileImageSchemas(BaseModel):
    path: str