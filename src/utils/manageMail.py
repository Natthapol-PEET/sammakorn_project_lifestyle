from email import encoders
from email.message import EmailMessage
from email.mime.base import MIMEBase
from smtplib import SMTP, SMTPException, SMTP_SSL
import ssl
import random
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

import codecs

from fastapi import HTTPException

from configs import config


# dotenv
from dotenv import dotenv_values

# creddentials
creddentials = dotenv_values(".env")


MAIL_USERNAME = creddentials['EMAIL']
MAIL_PASSWORD = creddentials['PASSWORD']
MAIL_FROM = creddentials['EMAIL']

to_addrs = "natthapol.n@ku.th"

message = MIMEMultipart("alternative")
message["From"] = MAIL_FROM


def readHtml(file: str):
    f = codecs.open(f"templates/{file}", 'r', 'utf-8')
    return f.read()


def registerAdminGuard(item, role):
    msg = EmailMessage()
    msg['Subject'] = f'Register {"Admin" if role == "admin" else "Guard"}'
    msg['From'] = MAIL_FROM
    msg['To'] = item.email

    html = readHtml("register_admin_guard.html")

    html = html.replace('this-full-name', f'{item.firstname} {item.lastname}')
    html = html.replace('this-role', "นิติบุคคล" if role == "admin" else "พนักงานรักษาความปลอดภัย")

    msg.set_content(html, subtype='html')

    try:
        context = ssl.create_default_context()
        with SMTP_SSL("smtp.gmail.com", 465, context=context) as smtp:
            smtp.login(MAIL_USERNAME, MAIL_PASSWORD)
            smtp.send_message(msg)

        return {"detail": "send email successful"}
    except:
        raise HTTPException(
                status_code=403, detail="ไม่สามารถส่ง email ได้ในขณะนี้")


def resetPasswordAndSendmail(item, key):
    msg = EmailMessage()
    msg['Subject'] = 'Forgot password'
    msg['From'] = MAIL_FROM
    msg['To'] = item.email

    html = readHtml("forget_password.html")

    html = html.replace('this-full-name', f'{item.firstname} {item.lastname}')
    html = html.replace('this-id-card', item.id_card)
    html = html.replace('this-home-number', f'{item.home_name} {item.home_number}')
    html = html.replace('this-license-plate', item.license_plate)
    html = html.replace('this-link', f"{config.forgotUrl}/?key={key}")

    msg.set_content(html, subtype='html')

    try:
        context = ssl.create_default_context()
        with SMTP_SSL("smtp.gmail.com", 465, context=context) as smtp:
            smtp.login(MAIL_USERNAME, MAIL_PASSWORD)
            smtp.send_message(msg)

        return {"detail": "send email successful"}
    except:
        raise HTTPException(
                status_code=403, detail="ไม่สามารถส่ง email ได้ในขณะนี้")




def register_resident(item, listHome):
    msg = EmailMessage()
    msg['Subject'] = 'Register Resident'
    msg['From'] = MAIL_FROM
    msg['To'] = item.email

    html = readHtml("register_resident.html")

    html = html.replace('this-full-name', f'{item.firstname} {item.lastname}')
    html = html.replace('this-id-card', item.id_card)

    home = ', '.join(map(str, listHome))
    html = html.replace('this-home-number', home)

    license = ', '.join(map(str, item.license_plate))
    html = html.replace('this-license-plate', license)

    msg.set_content(html, subtype='html')

    try:
        context = ssl.create_default_context()
        with SMTP_SSL("smtp.gmail.com", 465, context=context) as smtp:
            smtp.login(MAIL_USERNAME, MAIL_PASSWORD)
            smtp.send_message(msg)

        return {"detail": "send email successful"}
    except:
        raise HTTPException(
                status_code=403, detail="ไม่สามารถส่ง email ได้ในขณะนี้")


def sendMailToWhitelist(item, home, qrGenId, createDatetime):
    msg = EmailMessage()
    msg['Subject'] = 'Register Whitelist'
    msg['From'] = MAIL_FROM
    msg['To'] = item.email

    html = readHtml("register_whitelist.html")

    html = html.replace('this-full-name', f'{item.firstname} {item.lastname}')
    html = html.replace('this-id-card', item.id_card)
    html = html.replace('this-home-number', f"{home.name} {home.home_number}")
    html = html.replace('this-license-plate', item.license_plate)
    html = html.replace('this-qr-code', qrGenId)
    html = html.replace('this-create-date-time', createDatetime)

    msg.set_content(html, subtype='html')

    try:
        context = ssl.create_default_context()
        with SMTP_SSL("smtp.gmail.com", 465, context=context) as smtp:
            smtp.login(MAIL_USERNAME, MAIL_PASSWORD)
            smtp.send_message(msg)

        return {"detail": "send email successful"}
    except:
        raise HTTPException(
                status_code=403, detail="ไม่สามารถส่ง email ได้ในขณะนี้")



def sendMailRecoveryPassword(item, key: str, role: str):
    msg = EmailMessage()
    msg['Subject'] = 'Forgot password'
    msg['From'] = MAIL_FROM
    msg['To'] = item.email

    html = readHtml("forget_password.html")

    html = html.replace('this-full-name', f'{item.firstname} {item.lastname}')
    html = html.replace('this-id-card', item.id_card)
    html = html.replace('this-link', f"{config.forgotUrl}/?role={role}&key={key}")

    msg.set_content(html, subtype='html')

    try:
        context = ssl.create_default_context()
        with SMTP_SSL("smtp.gmail.com", 465, context=context) as smtp:
            smtp.login(MAIL_USERNAME, MAIL_PASSWORD)
            smtp.send_message(msg)

        return {"detail": "send email successful"}
    except:
        raise HTTPException(
                status_code=403, detail="ไม่สามารถส่ง email ได้ในขณะนี้")