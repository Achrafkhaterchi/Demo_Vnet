FROM python:3.8

WORKDIR /app

COPY vnet/vnet.py /app/vnet.py
COPY vnet/templates/vnet.xlsx /app/vnet.xlsx
COPY vnet/templates/vnet.j2 /app/vnet.j2

RUN pip install -r requirements.txt

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip && \
    unzip terraform_1.0.0_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.0.0_linux_amd64.zip

CMD ["python", "vnet.py"]
