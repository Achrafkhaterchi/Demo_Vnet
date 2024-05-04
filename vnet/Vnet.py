import os
import pandas as pd
from jinja2 import Template

# Obtenir le répertoire parent du fichier en cours d'exécution
parent_dir = os.path.dirname(os.path.abspath(__file__))

# Construire les chemins absolus à partir du répertoire parent
excel_file_path = os.path.join(parent_dir, 'vnet.xlsx')
template_file_path = os.path.join(parent_dir, 'vnet.j2')
output_file_path = os.path.join(parent_dir, 'variables.tfvars')

# Charger les données depuis le fichier Excel
df = pd.read_excel(excel_file_path)

nsg_ids = dict(zip(df['subnet_names'], df['nsg_id']))
resource_group_name = df['resource_group_name'].iloc[0]
use_for_each = str(df['use_for_each'].iloc[0]).lower()
vnet_location = df['vnet_location'].iloc[0]
address_space = df['address_space'].iloc[0]
route_tables_ids = dict(zip(df['subnet_names'], df['route_table_id']))
subnet_names = df['subnet_names'].tolist()
subnet_prefixes = df['subnet_prefixes'].tolist()

subnet_service_endpoints = {}
for index, row in df.iterrows():
    subnet = row['subnet_names']
    service_endpoints = row['service_endpoints'].split(', ') if isinstance(row['service_endpoints'], str) else []
    subnet_service_endpoints[subnet] = service_endpoints
    
tags = {}
for index, row in df.iterrows():
    tag_pairs = str(row['tags']).split(',')
    for pair in tag_pairs:
        if '=' in pair:
            key, value = pair.split('=')
            tags[key.strip()] = value.strip()

data = {
    'nsg_ids': nsg_ids,
    'resource_group_name': resource_group_name,
    'use_for_each': use_for_each,
    'vnet_location': vnet_location,
    'address_space': address_space,
    'route_tables_ids': route_tables_ids,
    'subnet_names': subnet_names,
    'subnet_prefixes': subnet_prefixes,
    'subnet_service_endpoints': subnet_service_endpoints,
    'tags': tags
}

# Charger le modèle Jinja2
with open(template_file_path, 'r') as file:
    template_content = file.read()

template = Template(template_content)

# Rendre le modèle avec les données
rendered_template = template.render(data)

# Écrire les données rendues dans un fichier variables.tfvars
with open(output_file_path, 'w') as file:
    file.write(rendered_template)

print("Le contenu a été écrit dans le fichier variables.tfvars avec succès.")
