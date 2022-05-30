

def isThaiNationalID(id: str):
    sum = 0
    for i in range(0, 12):
        sum += int(id[i]) * (13 - i)
    checkSum = (11 - sum % 11) % 10

    if checkSum == int(id[12]):
        return True
    else:
        return False
