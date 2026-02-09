# Project Configuration
project_name = "taskmanager"
environment  = "prod"
location     = "switzerlandnorth"

# VM Configuration
admin_username = "azureuser"
vm_size        = "Standard_D2s_v3"  # 2 vCPU, 4GB RAM

# Security 
admin_source_ip = "102.156.242.116/32" 
owner_email     = "chedli.masmoudi01@gmail.com"

# Generate key: ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_taskmanager
admin_ssh_public_key ="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDj6tyosBiW2JJJrOyHgU9iLQoExa7502ul+XCvIz8DCr+HbHM4FaoJaAsXb+1PjyCssx9+89tlunVsjuTZ5YFT6eHtYMAY2tZ3K6y5MCLxuaFl/PnA8AwW2Z01+yYVlTV9CFwNTcDmQGrApTRtuQnqSwHqd8nE8jSLoSaFdC6fqKg3kC2PoU+b8I7wLIHk3tpoIWGCk9JhtmWQJuq3MFdBZ4eN543vHzQT3i/OczGogFIXgf1AbZbEqXuSGA9qgp5myehTXiEK2BcsR/NvXaSbiJoXDuacqqGyzXmsimwiBiw6x1F2JHKIJZUojFwC4LxL+kY7axnAT6hcde4wd14R4rjm6+70j7LorCxCSTqSjct8wh2engcWYkz5HFW4KKKiriKW2kIyxb2hLGO/yieVqSjEPws9cpA5Hp10MbusLTgEW96CNWIKzhuLFxvm+294bYi74ggtXlz42n4qn4Rutv+iEUHtL4XRwhsq0hRZPDvnzjlEEJFvTJjKBMSxqZLD9kjy6hEHnCEWBCzi1E5vfvx02lqVazFppETeWLqfAe5nrl1o7/DLMF077UjhrTuH1/B5C+alu94zHrydwhzxm5s/X7KbhK3ETuNmMIm2JelAbAvy7l6qZhe91sg44dF8fUVwPUwqcZEfcOasjmHxehC7utfECjdUNGwVyNrcTQ== taskmanager-azure"