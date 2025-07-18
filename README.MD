Projeto DevOps com Vagrant e Ansible
Informações do Projeto
Disciplina: Administração de Sistemas Abertos
Professor: Leonidas Lima
Período: 2025.1
Instituição: Instituto Federal da Paraíba - Campus João Pessoa
Integrantes da Equipe

Lucas - Matrícula: 20232380005
Jaaziel - Matrícula: 202323800  15

Descrição do Projeto
Este projeto implementa uma infraestrutura virtualizada usando Vagrant e Ansible para automatizar o provisionamento e configuração de quatro máquinas virtuais que simulam um ambiente de produção completo com servidor de arquivos, banco de dados, aplicação web e cliente.
Objetivos

Desenvolver competências práticas em DevOps e Infraestrutura como Código (IaC)
Automatizar a configuração de sistemas Linux e serviços essenciais
Implementar práticas de segurança e gerenciamento de infraestrutura

Arquitetura da Solução
Topologia de Rede
192.168.56.0/24
├── arq.lucas.jaaziel.devops  (192.168.56.105) - Servidor de Arquivos
├── db.lucas.jaaziel.devops   (192.168.56.115) - Servidor de Banco de Dados  
├── app.lucas.jaaziel.devops  (192.168.56.155) - Servidor de Aplicação
└── cli.lucas.jaaziel.devops  (192.168.56.99)  - Cliente
Máquinas Virtuais
1. Servidor de Arquivos (arq)

IP: 192.168.56.105 (IP fixo)
RAM: 512 MB
Discos: 3 discos adicionais de 10GB cada
Serviços:

Servidor DHCP autoritativo
Servidor NFS
LVM (Logical Volume Manager)



2. Servidor de Banco de Dados (db)

IP: 192.168.56.115 (via DHCP com reserva)
RAM: 512 MB
Serviços:

MariaDB Server
Cliente NFS (autofs)



3. Servidor de Aplicação (app)

IP: 192.168.56.155 (via DHCP com reserva)
RAM: 512 MB
Serviços:

Apache2 Web Server
Cliente NFS (autofs)



4. Cliente (cli)

IP: 192.168.56.99 (via DHCP com reserva)
RAM: 1024 MB
Serviços:

Firefox ESR
Suporte a X11 Forwarding
Cliente NFS (autofs)



Tecnologias Utilizadas

Vagrant: Provisionamento de máquinas virtuais
Ansible: Automação de configuração
VirtualBox: Hipervisor
Debian Bookworm: Sistema operacional base
Docker: Não utilizado (projeto focado em VMs)

Pré-requisitos
Software Necessário

VirtualBox 6.1 ou superior
Vagrant 2.2 ou superior
Ansible 2.9 ou superior (apenas no host)

Configuração do Ambiente
bash# Instalar VirtualBox
sudo apt update
sudo apt install virtualbox

# Instalar Vagrant
wget https://releases.hashicorp.com/vagrant/2.4.0/vagrant_2.4.0_linux_amd64.zip
sudo unzip vagrant_2.4.0_linux_amd64.zip -d /usr/local/bin

# Instalar Ansible
sudo apt install ansible
Estrutura do Projeto
projeto-vagrant-ansible/
├── Vagrantfile                 # Configuração das VMs
├── inventory.ini              # Inventário do Ansible
├── playbooks/
│   ├── ansible.cfg           # Configuração do Ansible
│   ├── common.yml            # Configurações comuns
│   ├── arq.yml              # Playbook do servidor de arquivos
│   ├── db.yml               # Playbook do servidor de banco
│   ├── app.yml              # Playbook do servidor de aplicação
│   └── cli.yml              # Playbook do cliente
├── files/
│   ├── auto.master          # Configuração do autofs
│   ├── chrony.conf          # Configuração do NTP
│   ├── index.html           # Página web personalizada
│   ├── sshd_config          # Configuração do SSH
│   └── sudoers_ifpb         # Configuração do sudo
└── README.md                # Este arquivo
Como Executar
1. Clonar o Repositório
bashgit clone https://github.com/seu-usuario/projeto-vagrant-ansible.git
cd projeto-vagrant-ansible
2. Configurar Chaves SSH
bash# Gerar chave SSH se não existir
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
3. Iniciar as Máquinas
bash# Iniciar todas as máquinas
vagrant up

# Ou iniciar uma máquina específica
vagrant up arq
vagrant up db
vagrant up app
vagrant up cli
