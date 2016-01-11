Atmosphere's Ansible Instance Deployment Setup
==============================================

This is an extension point for [Atmosphere](https://github.com/iPlantCollaborativeOpenSource/atmosphere). It defines (with Ansible) how Atmosphere's instances deploy with the cloud provider. To look at how Atmosphere utilizes this modules, look at the [`service.deploy.py`](https://github.com/iPlantCollaborativeOpenSource/atmosphere/blob/master/service/deploy.py) and our [subspace](https://github.com/iPlantCollaborativeOpenSource/subspace) module.

Extension Point?
----------------
We use this term to denote that an installation of Atmosphere could customize / modify the actions performance when deploy virtual machine instances to a cloud provider by alter the [playbooks](ansible/playbooks) defined here. 


# License

See [LICENSE](LICENSE) file.
