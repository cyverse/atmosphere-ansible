# Troubleshooting Atmosphere Ansible Deployments

## Deployment Process

1. Instance is launched by Atmosphere.
	1. A call is made to OpenStack, or other cloud provider to launch an instance.
	1. The cloud provider request the user's image and delegates it to a compute host and starts the instance.  This may also be referred to as the `building` state.
	1. The cloud provider responds to Atmosphere signaling a successful or unsuccessful launch.
1. A "floating IP" is attached to the instance, so that it becomes reachable from the outside.  At this point the instance will have something similar to an `eth0` device with a non-routable IP assigned to it, and a `lo` or loopback adapter on the instance itself.  The floating IP is connected via the cloud provider via NAT so that the instance is able to connect to the internet and is accessible from the outside. It enters the state `active-networking` at this point.
1. Atmosphere checks to see if the instance is reachable via SSH using it's deployment private/public keypair.  If successful, it leaves `active-networking` state and proceeds to `active-deploying`
1. Atmosphere, if networking is still viable (there is a change that networking could be lost at this point, i.e. not pingable or SSH-able), it will hand the deployment process off to `Ansible`, and execute all defined `Playbooks` to completion.
	1. Each `playbook` will run against the instance one by one.  Once all `playbooks` have ran, a report stating the success/failure of the deploy via `Ansible` is generated, and if EITHER the instace became `unreachable` or contains `failures` of any kind, Atmosphere will re-deploy `Ansible` until the deploy complese successfully, or reaches it's execution limit and fails entirely.
	1. During this phase, one can check to see if `Ansible` is in fact running on your instance by verifying if there are any running `Ansible` processes.  See notes below on how to do this.
1.  Upon successful execution of all `Ansible` `playbooks`, Atmosphere will proceed to some additional, `non-Ansible` related tasks, and if successful, will enter state `Active`.
	1. If unsuccessful it will enter state "deploy_error"
	1. At this point, a user can request a "re-deploy" to attempt to have Atmosphere re-do a subset of the deployment tasks to fix the deployment error.

## Troubleshooting

### Testing Procedure
If at any point during the troubleshooting process, you are unable to move to the next step, stop and consider other issues.  Consider booting this instance on your own, or on another cloud.  Check Atmopshere `Celery` for errors/issues.  Consult others if all else fails.

1. Is the instance responding to pings?
	1. Ping the instance
	
		```
		ping -c 4 <instance-IP>
		```
	
	1. If successful proceed to next step.
1. Is the instance responding to SSH?
	1. If your key is present, you should be able to login via `root`
		
		```
		ssh -p 22 root@<instance-IP>
		``` 

	1. If you get a password prompt, SSH is working, however your key is not present.  Try to login using Cyverse/iPlant credentials.
		
		```
		ssh -p 22 <ATMOUSERNAME>@<instance-IP>
		```
	1. If either step is successful proceed to next step.
1. Once logged in, perform some basic tests
	1. Is `Ansible` still running? If so, check the `ELK` server for `Ansible` deployment logs and check for any deployment errors in the final report. 
		
		```
		sudo ps aux | grep 'ansible'
		```
		
	1. If `ELK` is inaccessible or down, tail the logs from the Atmosphere controller
		
		```
		tail -n 1000 -f /opt/dev/atmosphere/logs/atmosphere_deploy.log | grep <instance-id>
		```
		
	1. Verify that Atmosphere's deployment key is in `/root/.ssh/authorized_keys`.  This public key can be found on the Atmosphere server under `/opt/dev/atmosphere/extras/ssh/id_rsa.pub`.  Verfiy that these key's match.  If Atmosphere's key is not present, inject the public key, and re-deploy the instance.
	1. Verify network connectivity for deployment process.
		
		```
		ping -c 4 google.com
		ping -c 4 ldap.iplantcollaborative.org
		```
		
	1. Check to see if user accounts can be made.
		
		```
		sudo su - <ATMOUSERNAME>
		ls -la ~/  # This should contain at least the Desktop directory
		sudo df -hT  # This should contain two devices.  Disks /dev/vda and /dev/vdb.  Verify that both devices are not 100% full.
		sudo mount  # This should display /dev/vda mounted on '/' and /dev/vdb mounted on '/home'
		```
		
1. Verify operability through Atmosphere web-UI.
	1. IF the launched image has a GUI, verify that "Remote Desktop" is working.  This should be checked within Firefox, or manually using `RealVNC Viewer`
	2. Web Shell is functional (Not browser dependent).  Be sure to verify that login is possible after a maximum of two attempts.


### What to do upon failure
If one or more of the above steps fail, depending on the severity, outside action should be taken.  After all of these options have been exhausted, contact a member of the Atmosphere team.

Some additional tests to perform.

1. If host is neither no longer responding to pings or SSH, attempt a Reboot, and if that fails, attempt a Hard Reboot.
1. Check to see if the operating system booted and the instance is running.  If nothing is listed here, proceed to the next step to see the instance display.

	```
	ssh root@<openstack-controller>
	nova console-log <instance-id>
	```

1. If the host is still unreachable, or will not move into the deploying stat, verify that the image is not hung at boot, or in total system failure.
	1. Use `virt-manager` to connect to the console of the instance.  Steps to follow below.
	1. Copy the instance ID from the instance details page.
	1. Query the cloud provider for additional information (These instructions are based on the assumption that the cloud provider is OpenStack)
	1. SSH into a server capable of issuing `nova` commands
		
		```
		ssh <username>@<openstack-controller>
		```
	
	1. Get supplemental details for which compute host the instance is running on, and what KVM instance name it was assinged
		
		```
		nova show <instance-id>
		``` 
	
	1. Start `virt-manager` and connect to the compute host in which your instance is running by double clicking on the compute host.  This will then display a list of running instances on that node
	1. Find the instance, which has your KVM instance name, and double click the entry.
	1. Check console for boot errors.
1. If the instance is in any other state than listed above, attempt a re-deploy.
1. If unsuccessful, try launching the problem image on another cloud provider under a different account to attempt to reproduce errors, and troubleshoot from there.
1. Lastly, search our Wiki for steps to repair image, or fix image and request that it be imaged as a replacement to the broken image.