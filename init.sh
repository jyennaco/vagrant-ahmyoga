#!/bin/bash

##################### USER VARIABLES #####################

# Git repository for the chef-repo to be used for cookbooks
CHEF_REPO_GIT=https://github.com/jyennaco/chef-repo.git

# JSON file in the chef-repo to be used as the run_list
RUN_LIST_JSON=run_list.json

##########################################################

echo "Starting init.sh ..."

echo "Installing git ..."
yum -y install git

echo "git-cloning my chef-repo ..."
cd ~
git clone ${CHEF_REPO_GIT}
cd -

echo "Installing chef ..."
curl -L https://www.opscode.com/chef/install.sh | bash

echo "Creating directory: ~/chef-repo/.chef ..."
mkdir -p ~/chef-repo/.chef

echo "Creating knife.rb in ~/chef-repo/.chef ..."
KNIFE=~/chef-repo/.chef/knife.rb
touch ${KNIFE}

echo "Configuring knife.rb ..."
echo 'current_dir = File.dirname(__FILE__)' >> ${KNIFE}
echo 'log_level                :info' >> ${KNIFE}
echo 'log_location             STDOUT' >> ${KNIFE}
echo 'cookbook_path            ["#{current_dir}/../cookbooks"]' >> ${KNIFE}

echo "Creating solo.rb in ~/chef-repo ..."
SOLO=~/chef-repo/solo.rb
touch ${SOLO}

echo "Configuring solo.rb ..."
echo 'root = File.absolute_path(File.dirname(__FILE__))' >> ${SOLO}
echo 'file_cache_path root' >> ${SOLO}
echo 'cookbook_path root + "/cookbooks"' >> ${SOLO}

echo "Running chef-solo to configure this node ..."
RUN_LIST=~/chef-repo/${RUN_LIST_JSON}
chef-solo -c ${SOLO} -j ${RUN_LIST}

echo "init.sh complete!"

