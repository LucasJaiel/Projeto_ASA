Projeto - DevOps com Vagrant e Ansible

Disciplina: Administração de Sistemas Abertos

Professor: LEONIDAS LIMA 

Período: 2025.1 

Integrantes

    Lucas  - Matrícula: 20232380005

    Jaaziel  - Matrícula: 20232380015

1. Objetivo do Projeto

O objetivo deste projeto é desenvolver competências práticas em DevOps e Infraestrutura como Código (IaC) utilizando as ferramentas Vagrant e Ansible. O projeto provisiona uma infraestrutura virtual e automatiza a configuração do sistema operacional e de serviços essenciais. 

2. Tecnologias Utilizadas

    Vagrant 

Ansible 

VirtualBox 

Debian "bookworm64" 

Serviços Linux: SUDO, SSH, NFS, LVM, DHCP 


Para executar o projeto, você precisará ter o Vagrant e o VirtualBox instalados em seu sistema.

Clone este repositório:
git clone https://github.com/LucasJaiel/Projeto_ASA

Acesse o diretório do projeto:


cd <NOME_DO_DIRETORIO>

Execute o seguinte comando para provisionar e configurar as máquinas virtuais:
vagrant up

Este comando irá baixar a imagem do Debian, criar as quatro máquinas virtuais, configurar a rede e os discos, e executar os playbooks do Ansible para configurar todos os serviços necessários.

Para acessar as máquinas, você pode usar o comando vagrant ssh:
Bash

    vagrant ssh arq
    vagrant ssh db
    vagrant ssh app
    vagrant ssh cli


