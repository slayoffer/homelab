resource "proxmox_vm_qemu" "cloudinit-k3s-master" {
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"
    desc = "Cloudinit Ubuntu"
    count = 1
    onboot = true

    # The template name to clone this vm from
    clone = "ubuntu-cloud"

    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 2
    sockets = 1
    numa = false
    vcpus = 0
    cpu = "host"
    memory = 4096
    name = "k3s-master-0${count.index + 1}"

    cloudinit_cdrom_storage = "local"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local"
                  size = 22
                }
            }
        }
    }

    # Setup the ip address using cloud-init.
    # Keep in mind to use the CIDR notation for the ip.
    ipconfig0 = "ip=192.168.3.15${count.index + 1}/24,gw=192.168.3.1"
    ciuser = "ubuntu"
    nameserver = "192.168.3.68"
    sshkeys = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4l9u9qd4r7QEzfbH7hdVCGknCeY6XFzlTpXVbizy56ZRJqUraN4HvVnelWts23EiLYVAE+uRT2Y1LkT63EVIm9GtRjo8aVPMeLuJxT3Iv8ElkSVtwiOqxFG2jJySAiV0J6E//rJK/rwxV0upe8wLrZiLcaWBAfuOYKJSEOrFKlOLfuFTcxZXDsZN8h0M5VXjmSmJGl03sk225VTUuwL8vqqLAh93JK3qT+GDw4er4gUotcLPLBpQGvT73OvZIvJaWw9Jim52SeLfcqNCphDfvBB6+ZLv8Rak/1jihOAo+DxwkY8rROrZg6VYX8feBC+YqkJK9tVycYl1cp/FU9jkNSMyAxhroec7iKKeS//07jI1itLjnfonTheAAzF+qsznGEfQdEoRDv0DuNvN8oXfXsMDC1gHQNctoyZvH2leekl43JUd0tUn1UhN9VoNrUMdmMKBBhwoEgncKcXRZ4ntmnUX+YE3Di9/IttAooVDEoEL7ZM6osXktvzRoZePpPv8= slayo@HOMEPC
    EOF
}

resource "proxmox_vm_qemu" "cloudinit-k3s-worker" {
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"
    desc = "Cloudinit Ubuntu"
    count = 1
    onboot = true

    # The template name to clone this vm from
    clone = "ubuntu-cloud"

    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 2
    sockets = 1
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 4096
    name = "k3s-worker-0${count.index + 1}"

    cloudinit_cdrom_storage = "local"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local"
                  size = 22
                }
            }
        }
    }

    # Setup the ip address using cloud-init.
    # Keep in mind to use the CIDR notation for the ip.
    ipconfig0 = "ip=192.168.3.20${count.index + 1}/24,gw=192.168.3.1"
    ciuser = "ubuntu"
    nameserver = "192.168.3.68"
    sshkeys = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4l9u9qd4r7QEzfbH7hdVCGknCeY6XFzlTpXVbizy56ZRJqUraN4HvVnelWts23EiLYVAE+uRT2Y1LkT63EVIm9GtRjo8aVPMeLuJxT3Iv8ElkSVtwiOqxFG2jJySAiV0J6E//rJK/rwxV0upe8wLrZiLcaWBAfuOYKJSEOrFKlOLfuFTcxZXDsZN8h0M5VXjmSmJGl03sk225VTUuwL8vqqLAh93JK3qT+GDw4er4gUotcLPLBpQGvT73OvZIvJaWw9Jim52SeLfcqNCphDfvBB6+ZLv8Rak/1jihOAo+DxwkY8rROrZg6VYX8feBC+YqkJK9tVycYl1cp/FU9jkNSMyAxhroec7iKKeS//07jI1itLjnfonTheAAzF+qsznGEfQdEoRDv0DuNvN8oXfXsMDC1gHQNctoyZvH2leekl43JUd0tUn1UhN9VoNrUMdmMKBBhwoEgncKcXRZ4ntmnUX+YE3Di9/IttAooVDEoEL7ZM6osXktvzRoZePpPv8= slayo@HOMEPC
    EOF
}