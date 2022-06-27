from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from datetime import datetime

# auth
from auth.auth import AuthHandler
from auth.check import Check
from data.admin_schemas import CreateAdmin
from data.guard_schemas import CreateGuard

# data
from data.schemas import ChangePassword
from data.models import admin_account, guard_account, resident_account

# utils
from utils import manageMail

check = Check()


auth_handler = AuthHandler()


class Register:
    async def resident_change_password(self, db, items: ChangePassword):
        # check password is conrec
        hashed_old_password = auth_handler.get_password_hash(
            items.old_password)
        sql = f"SELECT password FROM resident_account WHERE resident_id = {items.resident_id}"
        result = jsonable_encoder(await db.fetch_one(sql))
        # print(f"hashed_old_password >> {hashed_old_password}")
        # print(f"result >> {result}")
        # print(f"items.old_password >> {items.old_password}")
        print(f"password >> {result['password']}")

        if not result or (not auth_handler.verify_password(items.old_password, result['password'])):
            raise HTTPException(
                status_code=401, detail="รหัสผ่านไม่ถูกต้อง")

        # change password
        hashed_new_password = auth_handler.get_password_hash(
            items.new_password)
        sql = f"UPDATE resident_account SET password = '{hashed_new_password}' WHERE resident_id = {items.resident_id}"
        await db.execute(sql)

        return {"status": True}

    async def register_admin(self, db, item: CreateAdmin):
        await check.check_admin(db, item)
        await check.check_guard(db, item)
        await check.check_in_blacklist(db, item)
        await check.check_thai_id(item)
        await check.check_email_admin(db, item)

        hashed_password = auth_handler.get_password_hash(
            item.password.replace(" ", ""))
        query = admin_account.insert().values(firstname=item.firstname.replace(" ", ""),
                                              lastname=item.lastname.replace(" ", ""), username=item.username.replace(" ", ""),
                                              password=hashed_password, email=item.email.replace(" ", ""),
                                              active_user=True, role=item.role, id_card=item.id_card.replace(" ", ""),
                                              create_datetime=datetime.now())
        last_id = await db.execute(query)

        # send email to admin
        manageMail.registerAdminGuard(item, 'admin')
        
        return {'detail': 'Create success', 'last_id': last_id}


    async def register_guard(self, db, item: CreateGuard):
        await check.check_guard(db, item)
        await check.check_admin(db, item)
        await check.check_in_blacklist(db, item)
        await check.check_thai_id(item)
        await check.check_email_guard(db, item)

        hashed_password = auth_handler.get_password_hash(
            item.password.replace(" ", ""))
        query = guard_account.insert().values(firstname=item.firstname.replace(" ", ""),
                                              lastname=item.lastname.replace(" ", ""), username=item.username.replace(" ", ""),
                                              password=hashed_password, email=item.email.replace(" ", ""),
                                              active_user=True, role=item.role, id_card=item.id_card.replace(" ", ""),
                                              create_datetime=datetime.now())
        last_id = await db.execute(query)

        # send email to admin
        manageMail.registerAdminGuard(item, 'guard')

        return {'detail': 'Create success', 'last_id': last_id}
