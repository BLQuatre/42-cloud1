setup:
	if [ ! -d .venv ]; then python3 -m venv .venv; fi
	. .venv/bin/activate && pip install -r requirements.txt
	cp example.inventory.ini inventory.ini
	cp example.vault.yml vault.yml

encrypt:
	. .venv/bin/activate && ansible-vault encrypt vault.yml

view-vault:
	. .venv/bin/activate && ansible-vault view vault.yml

ping:
	. .venv/bin/activate && ansible servers -m ping -i inventory.ini

inventory:
	. .venv/bin/activate && ansible-inventory -i inventory.ini --list

playbook:
	. .venv/bin/activate && ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass

.PHONY: setup encrypt view-vault ping inventory playbook
