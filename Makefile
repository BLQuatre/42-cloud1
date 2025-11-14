build_ssh:
	docker build -t alpine-ssh local

run_ssh:
	docker run -d -p $(SSH_PORT):22 alpine-ssh
