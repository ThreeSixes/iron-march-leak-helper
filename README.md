# Iron March leak helper
## Prerequisites:
 - [Docker](https://docs.docker.com/install/) must be installed
 - [Iron March leaked data](https://www.bellingcat.com/resources/how-tos/2019/11/06/massive-white-supremacist-message-board-leak-how-to-access-and-interpret-the-data/) should be downloaded to your computer.

## Background
This project is designed to automate and make ingesting the Iron March SQL dump easier and quicker for those who wish to see its contents. It creates a MySQL database directly from the leaked database dump which can be used for analysis, conversion to other formats using tools, and is easy to start up and shut down. The SQL leaks still contain SQl constructs like foreign keys, etc. so they could be more useful for specific types of analysis or conversion to other SQL database types.

This was written to make use of the SQL dumps easier for those who have a use for the data in MySQL format.

## Theory of operation
This project leverages docker-compose to pull down a MySQL 5.7 image, mounts the leaked SQL dump as a read-only file, and runs the SQL file against a newly created database called `iron_march`. The data from the ingested database is stored in the root of the project in a new folder called `mysql-data`. After the initial ingestion of the data you can start and stop the container at will and the ingestion process won't have to be run again unless the folder containing the MySQL data files is deleted or the contents modified.

## Project setup
1. Make sure you have installed the prerequisitie software and have downloaded the leaked data as specified in the `Prerequisites` section.
2. Decompress the leaked data zip file and move the folder into this project.
3. Rename the folder containing the leaked data to `iron_march_leaks`.
4. Execute `docker-compose up` in the project's root.
5. The container should download, start, and then you'll see some logs. The database will take some time to ingest. It's approximately 1.3 GB after being pulled into MySQL.
6. Once you see a line that looks something like `iron-march-mysql       | Version: '5.7.23'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)` it's ready for a connection. The intial setup is complete.

## Using the project
- The MySQL container will open up TCP 33060 for connections. It shouldn't interfere with any default MySQL installations on your system.
- Database connection information is as follows:
    - Host: `0.0.0.0`
    - Port: `33060`
    - User: `user`
    - Password: `user`
    - Database: `iron_march`
- When you're done using the database you can run `docker-compose down` and the database engine will shut down.
- When you want to use it again use `docker-compose up` to start it again.

## Resolving issues
### I broke the MySQL database or deleted something in it!
- This is easy to fix. Run `docker-compose down`, delete the `mysql-data` folder in the project (you might need root or admin permissions so use `sudo`), and then run `docker-compose up`. The database will be rebuilt automatically from the data provided in the leaks!

## Extras!
### Prerequisites
- Python (2.7 or 3.6). Most non-Windows operating systems have a System Python installed by default that should work.

### Tool list
- `tools/unix2date.py` - This is a simple utility that converts unix time stamps in the dump to a human-readable UTC date. For example run `./tools/unix2date.py 1458552669` where the number is a timestamp from the database. The output will yield something like this: `2016-03-21 09:31:09 UTC`

## Limitations and known issues
- **This is not supposed to be a production-quality configuration. Use it at your own risk.**
- This has only been tested on Linux systems, but should work on OS X. Windows users might need to fix paths in the docker-compose.yml file.
- Even after the database has been ingested Docker will still expect the SQL file to exist in the project.
- On Linux and potentially OSX systems you might need root permissions to delete the `mysql-data` folder. The Docker container will set the UID of the files and directories to 0 since the container runs MySQL as root. Just use `sudo` to delete the folder.
- For some reason MySQL will reject your database connection unless you use the `0.0.0.0` hostname. I have only tested it on Ubuntu 18.04 LTS. If someone knows why that is I'd love to hear from you.

## License
This project is licensed using the MIT license. A copy has been included with the repository.
