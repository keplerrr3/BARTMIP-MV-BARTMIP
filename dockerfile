FROM jupyter/base-notebook:python-3.12.0

WORKDIR /app

COPY requirements.txt ./
COPY *.ipynb ./

RUN pip install --no-cache-dir -r requirements.txt


CMD ["sh", "-c", "jupyter nbconvert --execute --to notebook *.ipynb"]