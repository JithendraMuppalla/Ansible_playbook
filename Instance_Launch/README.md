Role Name
=========

Installs SQL Server in standard Chevron way.

Requirements
------------

A newly provisioned VM with appropriate data drives attached and formatted.
This is usually done by calling ansible-role-azure-iaas, followed by 
ansible-role-prep-vm.

Role Variables
--------------

The domain of the SQL Server

    sqlserver_forest: "s02"

Single service account to be used for all services.

    sqlserver_default_service_account: "{{ sqlserver_forest }}\\svc-azuresql"
    sqlserver_default_service_password: "" 

List of features to be installed. The values are identical to what is passed
to the installer or DSC

    sqlserver_features:
      - "SQLENGINE"
      
Two options are supported: a single drive where everything goes on E, and 
a multi-drive setup using Chevron's standard E, F, and I
      
    sqlserver_single_drive: false

Mnemonic for the version to install. For values, see the dictionary in
vars/main.yml. Mostly controls the media to be used, and the root folder name
(i.e. SQL2016) that is applied to all install locations.

    sqlserver_version: "ent2016"

Currently always uses SQL mode. Role will fail if sqlserver_sa_password is
not set.

    sqlserver_security_mode: "SQL"
    sqlserver_sa_username: "sa"
    sqlserver_sa_password: ""

Instance name. Adding an instance using this role is not supported.

    sqlserver_instance_name:  "MSSQLSERVER"

Database collation

    sqlserver_collation: "SQL_Latin1_General_CP1_CI_AS"

Dependencies
------------

* Nuget provider for OneGet must have been installed.

Example Playbook
----------------



License
-------

MIT

Author Information
------------------

william.mckenzie@chevron.com
