Install docker
`brew cask install docker`

Install homebrew (optional)
`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

Install iTerm2 (optional)
`brew cask install iterm2`

Install Oh-My-Zsh for iTerm (optional)
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`

Install Azure Data Studio
`brew cask install azure-data-studio` or download from [Microsoft](https://docs.microsoft.com/en-us/sql/azure-data-studio/download?view=sql-server-2017) or `wget https://go.microsoft.com/fwlink/?linkid=2072737`

1. create a folder 

   `mkdir tsql`

2. Make sure the `docker-compose.yml` file is in the folder

   wget blah FOO 

3. run `docker-compose build tsql_db`

4. run `docker-compose run tsql_db`

   this may take a while the first time ~ 5 minutes depending on your internet connection

5. echo "$$MSSQL_SA_PASSWORD" that gives you something FOO

```
   sudo docker exec -it tsql /opt/mssql-tools/bin/sqlcmd 
    -S localhost -U SA -P '88285MSSQL_' -Q 'ALTER LOGIN SA WITH PASSWORD=SA_PASSWORD="fooPass123!"'
```

6. enter the bash prompt within the docker container 

   `cd /var/backups/`

   `wget https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Standard.bak`

   `mv WideWorldImporters-Standard wwi.bak` ## for convience

   `docker container ls` get the name it gives you FOO

`docker exec -it <container name here> "bash"`

7. Enter the TSQL shell

   /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'fooPass123!'

8. `CREATE LOGIN <username> WITH PASSWORD = 'fooPass123'

   GO` FOO

9. `docker-compose up`

   now open Azure Data Studio

   login with <username> 127.0.0.1

   change setting to enable preview features to True

   to reload use file /var/backups/wwi.bak

   to restore go to script
todo
alias sqlcmd="/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'fooPass123!'""
find some way to export username and passwords out as shell variables and automagically call them
make shell scripts to run the thing
