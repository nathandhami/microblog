Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_version = '>= 20160921.0.0'
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder "./", "/home/ubuntu/project"
  config.vm.provider "virtualbox" do |vb|
   vb.memory = "1024"
   vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"] 
  end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.add_recipe "baseconfig"
    #chef.channel = "stable"
    #chef.version = "12.10.24"
  end
end