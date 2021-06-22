from fastapi import FastAPI, status, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from typing import List

from database import database as db
import crud
import api

from schemas import Note, NoteIn
from schemas import VisitorIN, VisitorOUT, Blacklist, Whitelist, WhitelistLog, UpdateVisitor, \
    CreateResponse, UpdateVisitorResponse


tags_metadata = [
    {"name": "Visitor", "description": ""},
    {"name": "Blacklist", "description": ""},
    {"name": "Whitelist", "description": ""},
]

app = FastAPI(
    title="REST API using FastAPI PostgreSQL Async EndPoints (Sammakorn API)",
    openapi_tags=tags_metadata)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_origins=[
    #     "http://localhost:8000",
    #     "http://127.0.0.1:8000"
    # ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def startup():
    await db.connect()


@app.on_event("shutdown")
async def shutdown():
    await db.disconnect()


# @app.get("/notes/", response_model=List[Note], status_code=status.HTTP_200_OK)
# async def read_notes():
#     return await crud.read_notes(db, skip=0, take=20)


# @app.get("/notes/{note_id}/", response_model=Note, status_code=status.HTTP_200_OK)
# async def read_notes_id(note_id: int):
#     return await crud.read_notes_id(db, note_id=note_id)


# @app.post("/notes/", response_model=Note, status_code=status.HTTP_201_CREATED)
# async def create_note(note: NoteIn):
#     return await crud.create_note(db, note=note)


# @app.put("/notes/{note_id}/", response_model=Note, status_code=status.HTTP_200_OK)
# async def update_note(note_id: int, payload: NoteIn):
#     return await crud.update_note(db, note_id=note_id, payload=payload)


# @app.delete("/notes/{note_id}/", status_code=status.HTTP_200_OK)
# async def delete_note_id(note_id: int):
#     return await crud.delete_note_id(db, note_id=note_id)


# ------------------------------------- Application ---------------------------

@app.post("/register/visitor/", tags=["Visitor"], response_model=CreateResponse, status_code=status.HTTP_201_CREATED)
async def Register_Visitor(register: VisitorIN):
    return await api.Register_Visitor(db, register=register)


@app.post("/register/blacklist/", tags=["Blacklist"], response_model=CreateResponse, status_code=status.HTTP_201_CREATED)
async def Register_Backlist(register: Blacklist):
    return await api.Register_Backlist(db, register=register)


@app.post("/register/whitelist/", tags=["Whitelist"], response_model=CreateResponse, status_code=status.HTTP_201_CREATED)
async def Register_Whitelist(register: Whitelist):
    return await api.Register_Whitelist(db, register=register)

# ------------------------------------- End Application ---------------------------


# -------------------------------- Website ------------------------
@app.put("/visitor/", tags=["Visitor"], response_model=UpdateVisitorResponse, status_code=status.HTTP_200_OK)
async def Visitor_CheckIN(visitor_id: int, payload: UpdateVisitor):
    if visitor_id or payload.timestamp:
        return await api.Visitor_CheckIN(db, visitor_id=visitor_id, payload=payload)
    else:
        raise HTTPException(
            status_code=400, detail="visitor_id or timestamp not found")


@app.post("/register/whitelist_log/", tags=["Whitelist"], response_model=CreateResponse, status_code=status.HTTP_201_CREATED)
async def Register_Whitelist_log(register: WhitelistLog):
    return await api.Register_Whitelist_log(db, register=register)


@app.get("/visitor_all_item/", tags=["Visitor"], response_model=List[VisitorOUT], status_code=status.HTTP_200_OK)
async def visitor_ALL_item():
    return await api.visitor_All_item(db)


@app.get("/visitor_item/", tags=["Visitor"], response_model=List[VisitorOUT], status_code=status.HTTP_200_OK)
async def Visitor_Item(home_number: str = "0/0"):
    if home_number == "0/0":
        raise HTTPException(status_code=404, detail="Home number not found")
    return await api.Visitor_Item(db, home_number=home_number)


@app.get("/blacklist_item/", tags=["Blacklist"], response_model=List[Blacklist], status_code=status.HTTP_200_OK)
async def Blacklist_Item(home_number: str = "0/0"):
    if home_number == "0/0":
        raise HTTPException(status_code=404, detail="Home number not found")
    return await api.Blacklist_Item(db, home_number=home_number)


@app.get("/whitelist_item/", tags=["Whitelist"], response_model=List[Whitelist], status_code=status.HTTP_200_OK)
async def Whitelist_Item(home_number: str = "0/0"):
    if home_number == "0/0":
        raise HTTPException(status_code=404, detail="Home number not found")
    return await api.Whitelist_Item(db, home_number=home_number)


@app.get("/whitelist_log_item/", tags=["Whitelist"], response_model=List[WhitelistLog], status_code=status.HTTP_200_OK)
async def Whitelist_log_Item(home_number: str = "0/0"):
    if home_number == "0/0":
        raise HTTPException(status_code=404, detail="Home number not found")
    return await api.Whitelist_log_Item(db, home_number=home_number)


# -------------------------------- End Website ------------------------


@app.get("/get_all_items/",  status_code=status.HTTP_200_OK)
async def get_all_items():
    return await api.get_all_items(db)
