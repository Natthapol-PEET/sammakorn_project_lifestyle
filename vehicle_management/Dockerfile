FROM python:3

COPY ./app /src/app
WORKDIR /src/app

ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install dependencies:
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Run the application:
CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8080"]

# Run the application:
# COPY myapp.py .
# CMD . /opt/venv/bin/activate && exec python myapp.py
