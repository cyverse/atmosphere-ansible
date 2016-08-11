# Manually Deploying Atmosphere Ansible Code

Atmosphere has a semi-complex Instance Deployment process, in that it requires a lot of moving pieces to get a full deployment to occur.  This document shows how to duplicate a manual test of what Atmosphere is doing to deploy instances.

## Get code

The latest code (usually `master`) for Atmosphere Ansible.

### CyVerse Atmosphere

* Site: <https://github.com/iPlantCollaborativeOpenSource/atmosphere-ansible>
* Repository:

	```
	git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere-ansible.git repo-clone
	```

### Jetstream Atmosphere

* Site: <https://github.com/jetstream-cloud/atmosphere-ansible>
* Repository:

	```
	git clone https://github.com/jetstream-cloud/atmosphere-ansible.git repo-clone
	```

## Set up Environment

1. Change to code directory

	```
	cd <path-to-repo-clone>
	```

1. Copy `variables.ini.dist` to `variables.ini` and populate configuration variables. This example uses relative path names from the repository root:

	```
	[COMMON]
	ATMOSPHERE_ANSIBLE_DIR = .
	ATMOSPHERE_ANSIBLE_LOG_DIR = logs

	[ansible.cfg]
	ANSIBLE_FACT_CACHE_BACKEND = redis
	ANSIBLE_FACT_CACHE_TIMEOUT = 14400
	ANSIBLE_MANAGED_STR = Ansible managed: {file} modified on %Y-%m-%d %H:%M:%S by {uid} on {host}
	ANSIBLE_SSH_TIMEOUT = 10

	SUBSPACE_PLUGINS_DIR = ; /opt/env/atmo/lib/python2.7/site-packages/subspace/plugins
	SUBSPACE_CALLBACK_WHITELIST = ; play_logger
	SUBSPACE_NO_COWS = ; 1 or 0 , 0 = Cows and 1 = No Cows
	SUBSPACE_COW_SELECTION = ; default (NOTE: Only if NO_COWS == 0)
	```

1. Create logs directory in `<path-to-repo-clone>/ansible`

1. Use existing `hosts` and `group_vars`, if available locally, or create them

	```
	ln -s /opt/dev/atmosphere-ansible/ansible/hosts hosts
	ln -s /opt/dev/atmosphere-ansible/ansible/group_vars group_vars
	```

	OR

	- Clone group_vars/ and hosts from: <https://github.com/iPlantCollaborativeOpenSource/clank/tree/master/dist_files> into `<path-to-repo-clone>/ansible/`
	- Rename `hosts.dist` to `hosts`

1. Basic testing structure for Ansible hosts files and vars

	```
	## Set up testing group_vars for one cloud
	cd group_vars
	ln -s atmosphere-provider1 testing 		# Must be done for each cloud environment
	cd ..

	# Set up testing group_vars for multiple clouds
	cd group_vars
	ln -s atmosphere-provider1 testing1 		# Must be done for each cloud environment
	ln -s atmosphere-provider2 testing2 		# Must be done for each cloud environment
	cd ..

	```

	AND

	Add the following to `<path-to-repo-clone>/ansible/hosts` in `[atmosphere:children]` section (for multiple clouds, or use just `testing` for one cloud):
	```
	testing1
	testing2
	```
	At the end of the file, add test VMs and populate ansible_host with floating IP addresses:
	```
	[testing1]
	vm1-1 ansible_host=XXX.XXX.XXX.XXX ansible_port=22

	[testing2]
	vm2-1 ansible_host=XXX.XXX.XXX.XXX ansible_port=22
	```

1. Test Ansible `ping`. From root of cloned repository:

	```
	ansible atmosphere -m ping -i ansible/hosts --limit "vm1-1"
	vm1-1 | SUCCESS => {
	    "changed": false,
	    "ping": "pong"
	}
	```

1. Build an "All-the-things!" Playbook. From `<path-to-repo-clone>/ansible/`:

	```
	cat ansible/playbooks/utils/check_networking.yml >> all-the-pbs.yml && \
	cat ansible/playbooks/instance_deploy/*.yml | grep -v '\-\-\-' >> all-the-pbs.yml && \
	cat ansible/playbooks/user_deploy/*.yml | grep -v '\-\-\-' >> all-the-pbs.yml
	```

1. Build a deploy_vars.yml file in `<path-to-repo-clone>/ansible/` for easier deployments. (Use your own CyVerse account for ATMOUSERNAME; find VNCLICENSE on atmobeta in secrets.py.)

	```
	---

	ATMOUSERNAME: <ATMOUSERNAME-TO-USE>
	VNCLICENSE: <REALVNC-SERVER-LICENSE>
	```

1. Quickly generate group of test instances
	1. Copy instances from Atmosphere page and paste into file

		```
		## instances.txt
		AnsibleDeployTest
		Active
		60%
		Networking  10.0.1.25   Tiny1   Atmo Cloud - USA
		AnsibleDeployTest
		Active
		60%
		Networking  10.0.1.26   Tiny1   Atmo Cloud - USA
		AnsibleDeployTest
		Active
		60%
		Networking  10.0.1.27   Tiny1   Atmo Cloud - USA
		```

	1. Generate hosts

		```
		cat instances.txt | grep 10| awk '{ i++;printf "vm-%s ansible_host=%s ansible_port=22\n",i,$2}'
		```

1. Run Ansible. from `<path-to-repo-clone>/ansible/`:

	```
	ansible-playbook all-the-pbs.yml -i hosts -e @deploy_vars.yml --limit "vm-*"
	```
