{% set vmware_version = salt['pillar.get']('vmware:version', '9.0.5-1137270') %}



vmwaredirectory:
  file.directory:
    - name: /opt/vmware
    - makedirs: True


vmwaretar:
  file.managed:
    - name: /opt/vmware/VMwareTools-{{ vmware_version }}.tar.gz
    - source: salt://vmware-tools/files/VMwareTools-{{ vmware_version }}.tar.gz
    - require:
      - file.directory: /opt/vmware
  cmd.run:
    - name: tar -xf /opt/vmware/VMwareTools-{{ vmware_version }}.tar.gz 
    - cwd: /opt/vmware/
    - unless: file /opt/vmware/vmware-tools-distrib
    -  require:
       - file.managed: /opt/vmware/VMwareTools-{{ vmware_version }}.tar.gz


vmwareinstall:
  cmd.run:
    - name: /opt/vmware/vmware-tools-distrib/vmware-install.pl -d
    - unless: which vmtoolsd
    - require:
      - cmd.run: tar -xf /opt/vmware/VMwareTools-{{ vmware_version }}.tar.gz


