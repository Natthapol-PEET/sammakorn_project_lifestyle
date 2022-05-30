from smtplib import SMTP, SMTPException, SMTP_SSL
import ssl
import random
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# dotenv
from dotenv import dotenv_values

# creddentials
creddentials = dotenv_values(".env")


def get_random_string(length):
    # # choose from all lowercase letter
    # letters = string.ascii_lowercase
    # result_str = ''.join(random.choice(letters) for i in range(length))
    # print("Random string of length", length, "is:", result_str)
    # return result_str

    with open('utils/words.txt','r') as f:
        words = f.readlines()
        new_words = []
        
        for word in words:
            new_words.append(word.replace('\n', ''))
        f.close()

    n = random.randint(0, 999)
    return new_words[n]

MAIL_USERNAME = creddentials['EMAIL']
MAIL_PASSWORD = creddentials['PASSWORD']
MAIL_FROM = creddentials['EMAIL']

to_addrs = "natthapol.n@ku.th"

# print(f"MAIL_USERNAME: {MAIL_USERNAME}")
# print(f"MAIL_PASSWORD: {MAIL_PASSWORD}")
# print(f"MAIL_FROM: {MAIL_FROM}")

# message = """From: From Person <from@fromdomain.com>
# To: To Person <to@todomain.com>
# MIME-Version: 1.0
# Content-type: text/html
# Subject: SMTP HTML e-mail test

# This is an e-mail message to be sent in HTML format

# <b>This is HTML message.</b>
# <h1>This is headline.</h1>
# """

message = MIMEMultipart("alternative")
message["From"] = MAIL_FROM


def resetPasswordAndSendmail(to_addrs, new_password):
    global message
    message["Subject"] = "Reset password"
    message["To"] = to_addrs

    text = ""
    html = """\
<html>
<body>
    <p>สวัสดีครับ นี่คือรหัสผ่านใหม่ของคุณ</p>
    <p>"""+new_password+"""</p>
</body>
</html>
"""

    # Turn these into plain/html MIMEText objects
    part1 = MIMEText(text, "plain")
    part2 = MIMEText(html, "html")

    # Add HTML/plain-text parts to MIMEMultipart message
    # The email client will try to render the last part first
    message.attach(part1)
    message.attach(part2)

    context = ssl.create_default_context()
    with SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
        server.login(MAIL_USERNAME, MAIL_PASSWORD)
        server.sendmail(
            MAIL_USERNAME, to_addrs, message.as_string()
        )

    # try:
    #     server = SMTP("smtp.gmail.com", 587)
    #     server.starttls()
    #     server.login(MAIL_USERNAME, MAIL_PASSWORD)
    #     server.sendmail(MAIL_FROM, to_addrs, message)
    #     server.quit()
    #     print("Successfully sent email")
    # except SMTPException:
    #     print("Error: unable to send email")





def sendMailToWhitelist(to_addrs, qrCodeId, firstname, topic: str = "Register Whitelist"):
    global message
    message["Subject"] = topic
    message["To"] = to_addrs

    text = ""
    html = """\
<html>
<head>
    <!-- Include Bootstrap for styling -->
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" />
    <style>
        .qr-code {
            max-width: 200px;
            margin: 10px;
        }
    </style>
</head>
<body>
    <p>สวัสดี คุณ """+firstname+"""</p>
    <p>นี่คือ QR-Code สำหรับเข้าโครงการ</p>
    <img src="https://chart.googleapis.com/chart?cht=qr&chl=""" +qrCodeId+ """&chs=160x160&chld=L|0"
        class="qr-code img-thumbnail img-responsive" />
</body>
</html>
"""

    # Turn these into plain/html MIMEText objects
    part1 = MIMEText(text, "plain")
    part2 = MIMEText(html, "html")

    # Add HTML/plain-text parts to MIMEMultipart message
    # The email client will try to render the last part first
    message.attach(part1)
    message.attach(part2)

    context = ssl.create_default_context()
    with SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
        server.login(MAIL_USERNAME, MAIL_PASSWORD)
        server.sendmail(
            MAIL_USERNAME, to_addrs, message.as_string()
        )

#     message = f"""From: From Person <{MAIL_USERNAME}>
# To: To Person <{to_addrs}>
# Subject: 

# <h1>This is headline.</h1>
# """

    # server = SMTP("smtp.gmail.com", 587)
    # server.starttls()
    # server.login(MAIL_USERNAME, MAIL_PASSWORD)
    # server.sendmail(MAIL_FROM, to_addrs, message)
    # server.quit()


def sendMailRecoveryPassword(to_addrs: str, key: str, firstname: str, url: str, topic: str = "Recovery password"):
    global message
    message["Subject"] = topic
    message["To"] = to_addrs

    text = ""
    html = f"""\
<html>
<head>
</head>
<body>
    <p>สวัสดี คุณ {firstname}</p>
    <p>คลิกที่ link เพื่อตั้งค่ารหัสผ่านใหม่</p>
    <a href="{url}?key={key}">{url}?key={key}</a>
</body>
</html>
"""

    # Turn these into plain/html MIMEText objects
    part1 = MIMEText(text, "plain")
    part2 = MIMEText(html, "html")

    # Add HTML/plain-text parts to MIMEMultipart message
    # The email client will try to render the last part first
    message.attach(part1)
    message.attach(part2)

    context = ssl.create_default_context()
    with SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
        server.login(MAIL_USERNAME, MAIL_PASSWORD)
        server.sendmail(
            MAIL_USERNAME, to_addrs, message.as_string()
        )