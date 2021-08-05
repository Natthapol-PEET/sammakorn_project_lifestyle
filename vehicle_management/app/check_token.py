from fastapi.encoders import jsonable_encoder
from models import blacklist_token


async def is_token_blacklisted(db, token):
    query = blacklist_token.select().where(blacklist_token.c.TOKEN == token)
    value = jsonable_encoder(await db.fetch_one(query))

    if value is None:
        return False
    else:
        return True
