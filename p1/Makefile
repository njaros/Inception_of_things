help:
	@echo "\n\033[1mUtilisation:\033[0m\n"
	@echo " make up            Démarre les machines virtuelles"
	@echo " make status        Affiche le statut des machines virtuelles"
	@echo " make server        Connecte SSH à la machine virtuelle 'server'"
	@echo " make serverWorker  Connecte SSH à la machine virtuelle 'serverWorker'"
	@echo " make stop          Arrête les machines virtuelles"
	@echo " make destroy       Supprime les machines virtuelles"
	@echo " make suspend       Met les machines virtuelles en pause"
	@echo " make token         Supprime le token de connexion"
	@echo " make re            Supprime les machines virtuelles, le token et démarre les machines virtuelles"
	@echo " make restart       Redémarre les machines virtuelles"
	@echo "\n"

up:
	vagrant up

status:
	vagrant status

server:
	vagrant ssh njaros

serverWorker:
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

clean: stop destroy token
	rm -rf .vagrant

re: clean up

.PHONY: help up status server serverWorker stop destroy suspend token re restart