def generage_qr_code(prefix: str):
        import random
        qrCodeId = f'{prefix}'

        while len(qrCodeId) < 21:
            n = str(random.randint(0, 9))
            
            if qrCodeId[len(qrCodeId) -1] != n:
                qrCodeId += n

        return qrCodeId

    
def calculaetTwoTime(queryTime):
    from datetime import datetime

    # first = queryTime.split('.')[0]
    # last = str(datetime.now()).replace(' ', 'T').split('.')[0]
    # FMT = '%Y-%m-%dTH:%M:%S'
    # tdelta = datetime.strptime(last, FMT) - datetime.strptime(first, '%Y-%m-%d H:%M:%S')
    tdelta = datetime.now() - queryTime

    return tdelta.total_seconds()