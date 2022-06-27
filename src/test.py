import codecs
from email.message import EmailMessage
from smtplib import SMTP_SSL
import ssl

email_from = 'natthapol593@gmail.com'
password = 's x u r e t f c e j j g u h x y'
email_to = 'natthapol593@gmail.com'

def readHtml(file: str) -> str:
    f = codecs.open(f"templates/{file}", 'r', 'utf-8')
    return f.read()
    

msg = EmailMessage()
msg['Subject'] = 'Here is my newsletter'
msg['From'] = email_from
msg['To'] = email_to

html = readHtml("new.html")

html = html.replace('this-title', 'WELCOME TO ARTANI PROJECT')
html = html.replace('this-role', 'ลูกบ้าน')   # ลูกบ้าน, พนักงานรักษาความปลอดภัย, นิติบุคคล
html = html.replace('this-full-name', 'นัฐพล นนทะศรี')
html = html.replace('this-id-card', '1410501130726')
html = html.replace('this-home-number', 'lifestyle 1/10')
html = html.replace('this-license-plate', '123 กด')
html = html.replace('this-qr-code', 'W12345678952')
html = html.replace('this-create-date-time', '10-04-2541')
html = html.replace('this-link', 'www.google.com')

msg.set_content(html, subtype='html')


context = ssl.create_default_context()
with SMTP_SSL("smtp.gmail.com", 465, context=context) as smtp:
    smtp.login(email_from, password)
    smtp.send_message(msg)
