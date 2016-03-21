# RunalyzeVagrant
Vagrant configuration for a Runalyze development environment 


## What?
RunalyzeVagrant is a vagrant configuration that sets up a development environment for [Runalyze](http://www.runalyze.com/) based on an Ubuntu Cloud Image including
- an Apache webserver
- a MySQL database
- the latest development sources of Runalyze


## Installation
- download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- download and install [Vagrant](https://www.vagrantup.com/downloads.html)
- clone this repo:
```base
git clone https://github.com/flopp/RunalyzeVagrant.git
```


## Usage
From the `RunalyzeVagrant` directory run
```bash
vagrant up
```
This spins up a virtual machine containing a local installation o Runalyze.
Doing this the first time may take a while, since the os image (Ubuntu Wily) has to be downloaded, required packages have to be installed and the [Runalyze repository](https://github.com/Runalyze/Runalyze) has to be cloned.

Once the installation is finished, you can find your local version of Runalyze at [http://localhost:8080/runalyze](http://localhost:8080/runalyze)

Use 
```bash
vagrant halt
```
to shut down the virtual machine.

Use 
```bash
vagrant provision
```
to update the local copy of Runalyze, and cleanup the database and the configuration.

Use 
```bash
vagrant destroy
```
to complete delete the virtual machine.


## License
Copyright 2016 Florian Pigorsch. All rights reserved.

Use of this source code is governed by a MIT-style license that can be found in the LICENSE file.



