# Manually Deploying Atmosphere Ansible Code

Atmosphere has a semi-complex Instance Deployment process, in that it requires a lot of moving pieces to get a full deployment to occur.  This document shows how to duplicate a manual test of what Atmosphere is doing to deploy instances.

## Get code

The latest code (usually `master`) for Atmosphere Ansible.

### CyVerse Atmosphere

* Site: <https://github.com/iPlantCollaborativeOpenSource/atmosphere-ansible>
* Repository:

	```
	git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere-ansible.git /opt/dev/testing
	```

### Jetstream Atmosphere

* Site: <https://github.com/jetstream-cloud/atmosphere-ansible>
* Repository:

	```
	git clone https://github.com/jetstream-cloud/atmosphere-ansible.git /opt/dev/testing
	```

## Set up Environment

1. Change to code directory

	```
	cd <path-to-repo-clone>/ansible
	```
	
1. Verify correct `roles_path` and `fact_cache` time is used for test environment, defined in `ansible.cfg`

	```
	...
	roles_path    = roles			# Uses local path.  Sometimes is set to full path to roles
	...
	fact_caching = redis			# Ensure that redis is installed and running
	fact_caching_timeout = 14400	# Set to at least 4 hours.  Default is 24 hours
	...
	```
	
1. Use existing `hosts` and `group_vars` or create them

	```
	ln -s /opt/dev/atmosphere-ansible/ansible/hosts hosts
	ln -s /opt/dev/atmosphere-ansible/ansible/group_vars group_vars
	```
	
	OR
	
	Clone and modify files from: <https://github.com/iPlantCollaborativeOpenSource/clank/tree/master/dist_files> into `<path-to-repo-clone>/ansible/`
	
1. Basic testing structure for Ansible hosts files and vars

	```
	## Set up testing group_vars for one cloud
	cd group_vars
	ln -s atmosphere testing 		# Must be done for each cloud environment
	cd ..

	# Set up testing group_vars for multiple clouds
	cd group_vars
	ln -s atmosphere testing1 		# Must be done for each cloud environment
	ln -s atmosphere testing2 		# Must be done for each cloud environment
	cd ..

	```
	
	AND
	
	```
	## <path-to-repo-clone>/ansible/hosts
	
	---
	[atmo-cloud-1-ip-blocks]
	vm[0:1]-[0:255].domain.com ansible_port=22
	vm[2:3]-[0:255].domain.com ansible_port=22

	[atmo-cloud-2-ip-blocks]
	vm[4:5]-[0:255].domain.com ansible_port=22
	vm[6:7]-[0:255].domain.com ansible_port=22
	
	[atmosphere:children]
	atmo-cloud-1-ip-blocks
	atmo-cloud-2-ip-blocks
	testing1
	testing2
	
	[testing1]
	vm1-1 ansible_host=XXX.XXX.XXX.XXX ansible_port=22 # Use test instance FIP
	
	[testing2]
	vm2-1 ansible_host=XXX.XXX.XXX.XXX ansible_port=22 # Use test instance FIP
	
	```
	
1. Set IP for `testing[1,2]` host groups and test Ansible `ping`

	```
	## <path-to-repo-clone>/ansible/hosts
	
	# E.g. Instance IP: 10.0.1.25
	[testing1]
	vm1-1 ansible_host=10.0.1.25 ansible_port=22
	
	```
	
	Ansible Ping instance
	
	```
	ansible atmosphere -m ping -i hosts --limit "vm1-1"
	vm1-1 | SUCCESS => {
	    "changed": false,
	    "ping": "pong"
	}
	```
	
1. Build an "All-the-things!" Playbook

	```
	cat util_playbooks/check_networking.yml > all-the-pbs.yml && cat playbooks/*.yml | grep -v '\-\-\-' >> all-the-pbs.yml
	```
	
1. Build a `-e` vars file for easier deployments

	```
	cat << EOF > deploy_vars.yml
	---

	ATMOUSERNAME: <ATMOUSERNAME-TO-USE>
	VNCLICENSE: <REALVNC-SERVER-LICENSE>
	
	EOF
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
		
1. Run Ansible

	```
	ansible-playbook all-the-pbs.yml -i hosts -e @deploy_vars.yml --limit "vm-*"
	```