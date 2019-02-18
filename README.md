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

`$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`

__Install Azure Data Studio__

Run `$ brew cask install azure-data-studio` or download from [Microsoft](https://docs.microsoft.com/en-us/sql/azure-data-studio/download?view=sql-server-2017) or run `$ wget https://azuredatastudiobuilds.blob.core.windows.net/releases/1.4.5/azuredatastudio-macos-1.4.5.zip`.

__Look at the aliases I've created__

In the `docker_aliases` file I've made some aliases, most notable are `dbash` and `dcpdb`. `dbash` opens a docker bash shell, and `dcpdb` copies the database dump in your external file system to your internal docker container so it can be used for import.


## Instructions
1. Clone this repo

   `$ git clone https://github.com/jdeweese1/KSU_560_MSSQL_mac_setup.git`

3. Get docker up and running

   In the location of the repo run the following:
   `$ docker-compose run tsql_db`

   This may take a while the first time ~ 5 minutes depending on your internet connection

5. Change the SA (SQL Admin) password

In your terminal run the following:
 `$ echo "$$MSSQL_SA_PASSWORD"` that gives you something the current admin password for the database. Using the output of this command, change the admin password to something more memorable.

```Bash
   $ sudo docker exec -it tsql /opt/mssql-tools/bin/sqlcmd 
    -S localhost -U SA -P 'output_of_echo_here' -Q 'ALTER LOGIN SA WITH PASSWORD=SA_PASSWORD="fooPass123!"'
```

6. Download the database dump

   If this is your first time bringing up the project run the following to download the database dump:
   
   ```Bash
   $ wget https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Standard.bak
   $ mv WideWorldImporters-Standard.bak wwi.bak
   $ source docker_aliases
   $ dcpdb

   ```
   
   In a terminal shell outside of the docker container run the following:
   
   `$ docker container ls` 
   This gives you the name of the docker container, which may be helpful later.

7. Create your own database user (optional)
   
   Enter the bash shell inside the docker container:
   `$ dbash`
   Now enter the following to enter the interactive TSQL shell:

   `$ /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'fooPass123!'`
   
   Now that you are in the TSQL shell run the following to create a non admin account for yourself run the following:
   
   ```SQL
      CREATE LOGIN <username> WITH PASSWORD = 'fooPass123'
      GO
      ```

9. Connect to database engine with Azure Data Studio.

   In the terminal not in a docker container the following:
   
   `$ docker-compose up`

   Open Azure Data Studio
   
   Connect to address 127.0.0.1
   Login with `some_user_name` and `some_password`

   Change go to settings and change the setting "Enable Preview Features" to be on.

10. Restore the database

   In Azure Data Studio, go to open a new query tab, making sure you are on the `master` database. Make sure you copy the database file into the location `/var/opt/mssql/data/wwi.bak`. Open the `import_query.SQL` file in Data Studio and execute or paste the following into the query window:
   
```SQL 
RESTORE DATABASE [WWI] FROM DISK = N'/var/opt/mssql/data/wwi.bak'
WITH MOVE 'WWI_Primary'  TO N'/var/opt/mssql/data/WWI.mdf', 
MOVE 'WWI_UserData' TO N'/var/opt/mssql/data/WWI_UserData.ndf',
MOVE 'WWI_Log' TO N'/var/opt/mssql/data/WWI.ldf',
MOVE 'wwi_inmemory_data_1' to N'/var/opt/mssql/data/WWI_InMemory.ndf'
```
It should take about 30 seconds for this to finish importing data.

To verify that it succeeded run the following on the `WWI` database, and ensure there are 663 rows:
```SQL
   SELECT * 
   FROM Sales.Customers
```

TODO
- find some way to export username and passwords out as shell variables and automagically call them
   - direnv?
- make shell scripts to run the thing
- find some way to get persistent database storage using volumes instead of having to reimport database
