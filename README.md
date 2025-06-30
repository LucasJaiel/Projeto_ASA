# Projeto 01: DevOps com Vagrant e Ansible

## Visão Geral

Este projeto foi desenvolvido para a disciplina de **Administração de Sistemas Abertos**, com o objetivo de criar e configurar uma infraestrutura de múltiplos servidores de forma automatizada. Utilizando **Vagrant** para provisionar as máquinas virtuais e **Ansible** para automatizar a configuração de sistemas e serviços, o projeto implementa um ambiente de desenvolvimento completo, demonstrando práticas de Infraestrutura como Código (IaC).

### Detalhes do Projeto
* **Disciplina:** Administração de Sistemas Abertos
* **Professor:** Leonidas Lima
* **Período:** 2025.1
* **Equipe:**
    * Lucas Jaiel de Sousa Correia - 20232380005
    * Jaaziel Batista da Silva - 20232380015

---

## Arquitetura da Infraestrutura

O ambiente consiste em quatro máquinas virtuais (`arq`, `db`, `app`, `cli`) baseadas em "debian/bookworm64". Todas estão interconectadas em uma rede privada do tipo "host-only" (`192.168.56.0/24`), que permite a comunicação entre as VMs e também com o computador hospedeiro.

* **`arq` (Servidor de Arquivos e Serviços):**
    * **IP Estático:** `192.168.56.105`
    * **Hostname:** `arq.lucas.jaaziel.devops`
    * **Serviços:**
        * **Servidor DHCP:** Atua como o único servidor autoritativo da rede, fornecendo IPs para as outras VMs através de reservas de MAC e um range dinâmico.
        * **LVM:** Gerencia três discos adicionais de 10 GB em um Volume Group `dados`, com um Logical Volume `ifpb` de 15 GB montado em `/dados`.
        * **Servidor NFS:** Compartilha o diretório `/dados/nfs` para as outras máquinas da rede.

* **`db` (Servidor de Banco de Dados):**
    * **IP via DHCP:** Recebe o endereço fixo `192.168.56.115` do servidor `arq`.
    * **Hostname:** `db.lucas.jaaziel.devops`
    * **Serviços:**
        * Instalação do `mariadb-server`.
        * Cliente NFS com montagem automática (`autofs`) do compartilhamento de `arq`.

* **`app` (Servidor de Aplicação):**
    * **IP via DHCP:** Recebe o endereço fixo `192.168.56.55` do servidor `arq`.
    * **Hostname:** `app.lucas.jaaziel.devops`
    * **Serviços:**
        * Servidor web `apache2` com uma página `index.html` customizada.
        * Cliente NFS com montagem automática (`autofs`).

* **`cli` (Host Cliente):**
    * **IP via DHCP:** Recebe um endereço dinâmico (`192.168.56.50-100`) do servidor `arq`.
    * **Hostname:** `cli.lucas.jaaziel.devops`
    * **Serviços:**
        * Instalação dos pacotes `firefox-esr` e `xauth`.
        * Servidor SSH configurado para permitir encaminhamento de X11.
        * Cliente NFS com montagem automática (`autofs`).

---

## Instruções de Execução

Para provisionar e configurar o ambiente do zero, siga os passos abaixo.

### Pré-requisitos
* Vagrant
* VirtualBox
* Ansible

### Passo 1: (Execução Única) Desativar o Servidor DHCP do VirtualBox

O Vagrant, ao usar `private_network`, pode ativar um servidor DHCP no VirtualBox que entra em conflito com o nosso servidor customizado na `arq`. Para garantir que nosso servidor seja o único a operar, é necessário remover o servidor conflitante do VirtualBox. **Este comando precisa ser executado apenas uma vez** no seu computador.

1.  **Liste os servidores DHCP do VirtualBox:**
    ```bash
    vboxmanage list dhcpservers
    ```
2.  **Remova o servidor DHCP da rede `vboxnet0`:**
    O nome da rede geralmente é `HostInterfaceNetworking-vboxnet0`.
    ```bash
    VBoxManage dhcpserver remove --network="HostInterfaceNetworking-vboxnet0"
    ```

### Passo 2: Destruir o Ambiente Anterior (Se Existir)

Para garantir uma execução limpa a partir da configuração final, destrua quaisquer VMs existentes do projeto.
```bash
vagrant destroy -f
```

### Passo 3: Criar e Provisionar o Ambiente

Execute os comandos na ordem abaixo.

1.  **Crie as máquinas virtuais:**
    ```bash
    vagrant up
    ```
2.  **Execute a automação do Ansible:**
    Este comando irá configurar todos os serviços, redes e permissões, incluindo a renovação final dos IPs via DHCP.
    ```bash
    ansible-playbook ansible/site.yml
    ```

---

## Verificação e Testes

Após a execução bem-sucedida do Ansible, verifique os seguintes pontos:

1.  **Verificar IPs dos Servidores:**
    ```bash
    vagrant ssh db -c "hostname -I"
    # A saída deve incluir 192.168.56.115

    vagrant ssh app -c "hostname -I"
    # A saída deve incluir 192.168.56.55
    ```
2.  **Verificar Servidor Web:**
    * Abra um navegador no seu computador e acesse: `http://192.168.56.155`
    * A página customizada do projeto deve ser exibida.

3.  **Verificar Compartilhamento NFS:**
    * Crie um arquivo de teste no servidor `arq`:
        ```bash
        vagrant ssh arq -c "sudo touch /dados/nfs/teste.txt"
        ```
    * Verifique se o arquivo aparece em um dos clientes:
        ```bash
        vagrant ssh cli -c "ls /var/nfs/dados"
        # A saída deve listar "teste.txt"
        ```
4.  **Verificar Acesso `sudo` dos Usuários:**
    * Acesse uma VM: `vagrant ssh cli`
    * Defina uma senha para o usuário: `sudo passwd lucas`
    * Troque para o usuário criado: `su - lucas`
    * Execute um comando com sudo: `sudo whoami`. O comando deve retornar `root` sem pedir senha.

## Estrutura de Arquivos

```
.
├── ansible/
│   ├── files/
│   │   └── index.html
│   ├── playbook-app.yml
│   ├── playbook-arq.yml
│   ├── playbook-cli.yml
│   ├── playbook-comum.yml
│   ├── playbook-db.yml
│   ├── playbook-dhcp-renew.yml
│   ├── inventory
│   └── site.yml
├── ansible.cfg
├── README.md
└── Vagrantfile
```
