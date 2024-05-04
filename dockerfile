FROM python:3.8

WORKDIR /app

# Copier les fichiers Python et les templates dans le conteneur
COPY vnet/Vnet.py /app/vnet.py
COPY vnet/templates/vnet.xlsx /app/vnet.xlsx
COPY vnet/templates/vnet.j2 /app/vnet.j2
COPY vnet/main.tf /app/main.tf
COPY vnet/variables.tf /app/variables.tf

# Copier le fichier des dépendances Python et installer les dépendances
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Télécharger et installer Terraform
RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip && \
    unzip terraform_1.0.0_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.0.0_linux_amd64.zip

# Copier les fichiers Terraform dans le conteneur
COPY vnet/ /app/vnet/

# Exécuter les commandes Terraform lors du démarrage du conteneur
CMD ["sh", "-c", "python vnet.py && terraform init && terraform plan -var-file=app/variables.tfvars && terraform apply -var-file=app/variables.tfvars"]
