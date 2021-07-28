from fastapi import FastAPI

api_app = FastAPI()


@api_app.get('/')
def test():
    return {'message': 'unprotected api_app endpoint'}
