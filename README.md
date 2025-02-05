This repository contains the fifth project for the Relational Database course on FreeCodeCamp. It includes a `.sql` dump file that can be loaded into a database for practice. To load the dump file, you can use the MySQL or PostgreSQL command line by running `mysql -u [username] -p [database_name] < number_guess.sql` or `psql -U [username] -d [database_name] -f number_guess.sql`. Alternatively, graphical tools can be used to import the file through their respective import options.

### Running the scripts

- `number_guess.sh` - This script generates a random number between 1 and 1000 that the user has to guess. Based on the number guessed, the script will tell the user whether the target number is higher or lower. Once guessed, it informs the user and saves info on the game in the database. Run it using: `./number_guess.sh` in a bash terminal and follow the prompts.
