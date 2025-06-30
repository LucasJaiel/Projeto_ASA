# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Configurações comuns a todas as VMs
  config.vm.box = "debian/bookworm64"
  config.ssh.insert_key = false
  config.vm.provider "virtualbox" do |v|
    v.linked_clone = true
    v.check_guest_additions = false
  end
  config.vm.boot_timeout = 300
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # VM: Servidor de Arquivos (arq)
  config.vm.define "arq" do |arq|
    arq.vm.hostname = "arq.lucas.jaaziel.devops"
    arq.vm.network "private_network", ip: "192.168.56.105"
    arq.vm.provider "virtualbox" do |v|
      v.name = "arq"
      v.memory = 512
      # Cria 3 discos adicionais de 10GB cada
      unless Dir.exist?(File.join(Dir.pwd, ".vagrant", "machines", "arq", "virtualbox")) && File.exist?(File.join(Dir.pwd, ".vagrant", "machines", "arq", "virtualbox", "disk-1.vdi"))
        v.customize ['createhd', '--filename', File.join(Dir.pwd, ".vagrant", "machines", "arq", "virtualbox", "disk-1.vdi"), '--size', 10 * 1024]
        v.customize ['createhd', '--filename', File.join(Dir.pwd, ".vagrant", "machines", "arq", "virtualbox", "disk-2.vdi"), '--size', 10 * 1024]
        v.customize ['createhd', '--filename', File.join(Dir.pwd, ".vagrant", "machines", "arq", "virtualbox", "disk-3.vdi"), '--size', 10 * 1024]
      end
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', File.join(Dir.pwd, ".vagrant", "machines", "arq", "virtualbox", "disk-1.vdi")]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', File.join(Dir.pwd, ".vagrant", "machines", "arq", "virtualbox", "disk-2.vdi")]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', File.join(Dir.pwd, ".vagrant", "machines", "arq", "virtualbox", "disk-3.vdi")]
    end
  end

  # VM: Servidor de Banco de Dados (db)
  config.vm.define "db" do |db|
    db.vm.hostname = "db.lucas.jaaziel.devops"
    db.vm.network "private_network", type: "dhcp"
    db.vm.provider "virtualbox" do |v|
      v.name = "db"
      v.memory = 512
      v.customize ["modifyvm", :id, "--macaddress2", "080027829700"]
    end
  end

  # VM: Servidor de Aplicação (app)
  config.vm.define "app" do |app|
    app.vm.hostname = "app.lucas.jaaziel.devops"
    app.vm.network "private_network", type: "dhcp"
    app.vm.provider "virtualbox" do |v|
      v.name = "app"
      v.memory = 512
      v.customize ["modifyvm", :id, "--macaddress2", "0800277ac944"]
    end
  end

  # VM: Host Cliente (cli)
  config.vm.define "cli" do |cli|
    cli.vm.hostname = "cli.lucas.jaaziel.devops"
    cli.vm.network "private_network", type: "dhcp"
    cli.vm.provider "virtualbox" do |v|
      v.name = "cli"
      v.memory = 1024
    end
  end
end
