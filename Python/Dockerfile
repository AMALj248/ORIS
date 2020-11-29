FROM python:3.7

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app

ADD . /app

EXPOSE 8000

CMD ["uvicorn", "omr:app", "--host", "0.0.0.0", "--port", "8000"]