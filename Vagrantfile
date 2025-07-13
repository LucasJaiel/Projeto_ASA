# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Desabilitar DHCP do Virtualbox
  config.trigger.before :"Vagrant::Action::Builtin::WaitforCommunicator", type: :action do |t|
     t.warn = "Interrompe o servidor dhcp do virtualbox"
     t.run = {inline: "vboxmanage dhcpserver stop --interface vboxnet0"}
  end	
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.linked_clone = true
    vb.check_guest_additions = false
  end

  # Servidor de Arquivos (arq)
  config.vm.define "arq" do |arq|
    arq.vm.hostname = "arq.lucas.jaaziel.devops"
    arq.vm.network :private_network, ip: "192.168.56.105"
    
    (0..2).each do |i|
      arq.vm.disk :disk, 
        size: "10GB", 
        name: "arq-disk#{i}",
        type: "sata",  # Forçar tipo SATA para aparecer como /dev/sd[b-d]
        storage_controller: "SATA Controller"
    end

    arq.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/arq.yml"
      ansible.inventory_path = "inventory.ini"
    end
  end

  # Servidor de Banco de Dados (db) - MAC fixo
  config.vm.define "db" do |db|
    db.vm.hostname = "db.lucas.jaaziel.devops"
    db.vm.network :private_network, type: "dhcp", mac: "080027111111"
    
    db.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/db.yml"
      ansible.inventory_path = "inventory.ini"
    end
  end

  # Servidor de Aplicação (app) - MAC fixo
  config.vm.define "app" do |app|
    app.vm.hostname = "app.lucas.jaaziel.devops"
    app.vm.network :private_network, type: "dhcp", mac: "080027222222"
    
    app.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/app.yml"
      ansible.inventory_path = "inventory.ini"
    end
  end

  # Cliente (cli) - MAC fixo e IP dentro da faixa
  config.vm.define "cli" do |cli|
    cli.vm.hostname = "cli.lucas.jaaziel.devops"
    cli.vm.network :private_network, type: "dhcp", mac: "080027333333"
    
    cli.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end

    cli.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbooks/cli.yml"
      ansible.inventory_path = "inventory.ini"
    end
  end
end
