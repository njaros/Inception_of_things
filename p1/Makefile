default:
	vagrant up

status:
	vagrant status

server:
	vagrant ssh jereverd

worker:
	vagrant ssh jrinna

stop:
	vagrant halt

restart:
	vagrant reload

destroy:
	vagrant destroy -f

suspend:
	vagrant suspend

token:
	rm -rf vagrant_shared_space

clean: destroy token
	rm -rf .vagrant

re: clean default

.PHONY: default status server worker stop destroy suspend token re restart