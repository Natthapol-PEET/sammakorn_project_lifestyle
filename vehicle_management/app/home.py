from .models import home, resident_home
from .schemas import HomeIn, ResidentHomeIn
from datetime import datetime


class Home:
    async def Add_Home(self, db, Home: HomeIn):
        query = home.insert() \
            .values(home_name=Home.home_name,
                home_number=Home.home_number,
                stamp_count=0,
                create_datetime=datetime.now())
        last_record_id = await db.execute(query)

        return {**Home.dict(), "id": last_record_id}


    async def Add_Resident_Home(self, db, ResidentHome: ResidentHomeIn):
        query = resident_home.insert() \
            .values(resident_id=ResidentHome.resident_id,
                home_id=ResidentHome.home_id,
                create_datetime=datetime.now())
        await db.execute(query)

        return {**ResidentHome.dict()}

    
    async def get_all_home(self, db):
        query = "SELECT CONCAT(home_name, ' - ', home_number) AS home FROM home"
        return await db.fetch_all(query)
