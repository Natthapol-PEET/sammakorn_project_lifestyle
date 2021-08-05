from data.models import notes
from data.schemas import NoteIn


async def read_notes(db, skip: int = 0, take: int = 20):
    query = notes.select().offset(skip).limit(take)
    return await db.fetch_all(query)


async def read_notes_id(db, note_id: int):
    query = notes.select().where(notes.c.id == note_id)
    return await db.fetch_one(query)


async def create_note(db, note: NoteIn):
    query = notes.insert().values(text=note.text, completed=note.completed)
    last_record_id = await db.execute(query)
    return {**note.dict(), "id": last_record_id}


async def update_note(db, note_id: int, payload: NoteIn):
    query = notes.update().where(notes.c.id == note_id).values(
        text=payload.text, completed=payload.completed)
    await db.execute(query)
    return {**payload.dict(), "id": note_id}


async def delete_note_id(db, note_id: int):
    query = notes.delete().where(notes.c.id == note_id)
    await db.execute(query)
    return {"message": "Note with id: {} deleted successfully!".format(note_id)}
