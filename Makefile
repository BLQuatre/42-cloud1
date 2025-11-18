SSH_PORT ?= 2222

run:
	docker run -d -p $(SSH_PORT):22 ubuntu-srv

setup:
	if [ ! -d .venv ]; then python3 -m venv .venv; fi
	. .venv/bin/activate && pip install -r requirements.txt

build:
	docker build -t ubuntu-srv -f local/Dockerfile .

ping:
	ansible servers -m ping -i inventory.ini

inventory:
	ansible-inventory -i inventory.ini --list

playbook:
	ansible-playbook -i inventory.ini playbook.yml

.PHONY: run setup build ping inventory playbook
