AMI_SLUG = Ubuntu
AMI_NAME_SUFFIX_ENCRYPTED = -encrypted
AWS_PROFILE = default
AWS_REGION = eu-central-1
DELETE_ON_TERMINATION = true
ENCRYPT_BOOT = false
INSTANCE_TYPE = m3.medium
KEEP_RELEASES = 3
ON_ERROR = ask
SHUTDOWN_BEHAVIOR = terminate
SOURCE_AMI=ami-3f1bd150
PLAYBOOK_FILE=ansible.yaml
ANSIBLE_GROUP = packer
SSH_PTY = false
SSH_TIMEOUT = 5m
SSH_USERNAME = ubuntu
AMI_SLUG_BASE = base
AMI_DESCRIPTION_BASE=UbuntuByMilija
AMI_NAME_BASE = eiq-$(AMI_SLUG)-$(AMI_SLUG_BASE)



.PHONY: debug-packer
debug-packer:
	$(eval PACKER_DEBUG := -debug)


.PHONY: debug-ansible
debug-ansible:
	$(eval ANSIBLE_DEBUG := -$(ANSIBLE_VERBOSITY_LEVEL))

 
.PHONY: force
force:
	$(eval PACKER_FORCE := -force)
	@echo "Enabling forced building mode for Packer"
	@echo

.PHONY: on-error
	$(eval PACKER_ONERROR := -on-error=$(ON_ERROR)) \



PACKER= \
	export AWS_PROFILE="$(AWS_PROFILE)" && \
	packer \
		build \
			$(PACKER_DEBUG) \
			$(PACKER_FORCE) \
			$(PACKER_ONERROR) \
			-var "ansible_group=$(ANSIBLE_GROUP)" \
			-var "delete_on_termination=$(DELETE_ON_TERMINATION)" \
			-var "instance_type=$(INSTANCE_TYPE)" \
			-var "keep_releases=$(KEEP_RELEASES)" \
			-var "region=$(AWS_REGION)" \
			-var "shutdown_behavior=$(SHUTDOWN_BEHAVIOR)" \
			-var "spot_price=$(SPOT_PRICE)" \
			-var "spot_price_auto_product=$(SPOT_PRICE_AUTO_PRODUCT)" \
			-var "ssh_username=$(SSH_USERNAME)" \
			-var "ssh_pty=$(SSH_PTY)" \
			-var "ssh_timeout=$(SSH_TIMEOUT)" \




.PHONY: base

base:
	@echo && \
	echo "Building \`$(AMI_SLUG_BASE)\` image" && \
	echo && \
		$(PACKER) \
		-var "ami_name=$(AMI_NAME_BASE)$(AMI_NAME_SUFFIX_ENCRYPTED)" \
		-var "ami_description=$(AMI_DESCRIPTION_BASE)" \
		-var "playbook_file=$(PLAYBOOK_FILE)" \
		  -var "source_ami=$(SOURCE_AMI)" \
		"image.json"
