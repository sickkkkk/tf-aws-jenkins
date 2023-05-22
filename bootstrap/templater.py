import json

# Load the JSON data from a file
with open('template_input.json', 'r') as file:
    data = json.load(file)

# Load the template bash script from a file
with open('template.sh', 'r') as file:
    template = file.read()

for key, value in data.items():
    if key == "ecr_repo_endpoint":
        string_value = value['value']
        string_value = string_value.split("/")[0]
        value['value'] = string_value
    placeholder = '{ ' + key + ' }'
    template = template.replace(placeholder, value['value'])

# Write the final bash script to a file
with open('bootstrap-efs.sh', 'w') as file:
    file.write(template)