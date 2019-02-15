# How to use the MSSQL engine on macOS using Docker

## Prerequisites

__Install homebrew (optional)__

`$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

__Install docker__

Use `$ brew cask install docker` or download from [Docker Website](https://hub.docker.com/editions/community/docker-ce-desktop-mac).



__Install iTerm2 (optional)__

Not required, but may make your life easier.

`$ brew cask install iterm2` or download from [iTerm website](https://iterm2.com/downloads.html)

__Install Oh-My-Zsh for iTerm (optional)__

This is reccomended, but probably not required. I won't gurantee using bash won't break something later. 

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`

__Install Azure Data Studio__

Run `$ brew cask install azure-data-studio` or download from [Microsoft](https://docs.microsoft.com/en-us/sql/azure-data-studio/download?view=sql-server-2017).

1. Clone this repo

   `$ git clone FOO`

3. run `docker-compose run tsql_db`

   This may take a while the first time ~ 5 minutes depending on your internet connection

5. echo "$$MSSQL_SA_PASSWORD" that gives you something FIXME

```Bash
   sudo docker exec -it tsql /opt/mssql-tools/bin/sqlcmd 
    -S localhost -U SA -P '88285MSSQL_' -Q 'ALTER LOGIN SA WITH PASSWORD=SA_PASSWORD="fooPass123!"'
```

6. Enter the bash prompt within the docker container 
   `$ docker exec -it <container name here> "bash"`
   
   Now you should be in bash shell inside the docker container.
   
   ```Bash
   $ cd /var/backups/
   $ wget https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Standard.bak
   $ mv WideWorldImporters-Standard wwi.bak
   ```
   
   In a terminal shell outside of the docker container run this:
   
   `$ docker container ls` get the name it gives you FOO

7. Enter the TSQL shell
   
   Make sure you are in the bash shell inside the docker container and run the following to enter the interactive TSQL shell.

   `$ /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'fooPass123!'`
   
   Now that you are in the TSQL shell run the following to create a non admin account for yourself run the following:
   
   ```CREATE LOGIN <username> WITH PASSWORD = 'fooPass123'
      GO```
      
      FIXME

9. Connecting to database engine with Azure Data Studio

   In the terminal not in a docker container the following:
   
   `docker-compose up`

   Open Azure Data Studio
   
   Connect to 127.0.0.1
   login with <username> 

   change setting to enable preview features to True

   to reload use file /var/backups/wwi.bak

   to restore go to script
todo

find some way to export username and passwords out as shell variables and automagically call them
make shell scripts to run the thing
