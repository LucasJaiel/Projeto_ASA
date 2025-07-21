# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Configuração global
  config.vm.box = "debian/bookworm64"
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Configuração do provider VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.linked_clone = true
    vb.check_guest_additions = false
  end

  # ──────────────── TRIGGERS ────────────────
  # 1. Antes do 'up', gerar as chaves SSH
  config.trigger.before :up do |trigger|
    trigger.name = "Gerar chaves SSH"
    trigger.run do |t|
      t.inline = <<-SHELL
        mkdir -p files/keys
        ssh-keygen -t rsa -b 4096 -f files/keys/lucas_id_rsa -q -N "" -y
        ssh-keygen -t rsa -b 4096 -f files/keys/jaaziel_id_rsa -q -N "" -y
      SHELL
    end
  end

  # 2. Após 'up', adicionar chaves ao agente SSH
  config.trigger.after :up do |trigger|
    trigger.name = "Adicionar chaves ao SSH Agent"
    trigger.run do |t|
      t.inline = <<-SHELL
        eval "$(ssh-agent -s)"
        ssh-add files/keys/lucas_id_rsa 2>/dev/null || echo "Chave lucas já adicionada"
        ssh-add files/keys/jaaziel_id_rsa 2>/dev/null || echo "Chave jaaziel já adicionada"
        echo "Chaves adicionadas ao SSH Agent!"
      SHELL
    end
  end
 #3. Antes de se comunicar com a VM, desligar o DHCP da vboxnet0
  config.trigger.before :"Vagrant::Action::Builtin::WaitForCommunicator", type: :action do |t|
    t.warn = "Interrompe o servidor dhcp do virtualbox"
    t.run = {inline: "vboxmanage dhcpserver modify --interface vboxnet0 --disable"}
  end

  # ──────────────── DEFINIÇÃO DAS MÁQUINAS ────────────────

  # Servidor de Arquivos (arq)
  config.vm.define "arq" do |arq|
    arq.vm.hostname = "arq.lucas.jaaziel.devops"
    arq.vm.network "private_network", ip: "192.168.56.105"

    (0..2).each do |i|
      arq.vm.disk :disk, size: "10GB", name: "arq-disk#{i}"
    end

    arq.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/arq.yml"
    end
  end

  # Servidor de Banco de Dados (db)
  config.vm.define "db" do |db|
    db.vm.hostname = "db.lucas.jaaziel.devops"
    db.vm.network "private_network", type: "dhcp", mac: "080027111111"
    db.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/db.yml"
    end
  end

  # Servidor de Aplicação (app)
  config.vm.define "app" do |app|
    app.vm.hostname = "app.lucas.jaaziel.devops"
    app.vm.network "private_network", type: "dhcp", mac: "080027222222"
    app.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/app.yml"
    end
  end

  # Host Cliente (cli)
  config.vm.define "cli" do |cli|
    cli.vm.hostname = "cli.lucas.jaaziel.devops"
    cli.vm.network "private_network", type: "dhcp"
    cli.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end
    cli.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/cli.yml"
    end
  end
end

