import enum

class DataClass(enum.Enum):
    # guard
    comming = "comming"
    checkout = "checkout"

    # admin
    adminStamp = "stamp"
    registerWhitelist = "whitelist"
    deleteWhitelist = "whitelist"
    registerBlacklist = "blacklist"
    deleteBlacklist = "blacklist"