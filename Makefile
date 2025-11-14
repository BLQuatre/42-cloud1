run:
	docker run -d -p $(SSH_PORT):22 ubuntu-srv

build:
	docker build -t ubuntu-srv -f local/Dockerfile .

ping:
	ansible servers -m ping -i inventory.ini

inventory:
	ansible-inventory -i inventory.ini --list

playbook:
	ansible-playbook -i inventory.ini playbook.yml
