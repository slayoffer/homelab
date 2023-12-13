#!/bin/bash

echo "Select a MySQL container to use:"
# List Docker containers starting with "ac-database" and prompt the user to select one
container_list=$(docker ps --format '{{.Names}}' | grep "^ac-database")
select CONTAINER_NAME in $container_list; do
    if [ -n "$CONTAINER_NAME" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Prompt for MySQL username and password
# Prompt the user to select the db username
echo "Select the db user to use:"
select MYSQL_USER in root; do
    if [ -n "$MYSQL_USER" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Prompt the user to select the db password
echo "Select the db user to use:"
select MYSQL_PASSWORD in password; do
    if [ -n "$MYSQL_PASSWORD" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
# echo "Enter MySQL username:"
# read -r MYSQL_USER

# echo "Enter MySQL password:"
# The -s flag hides the user's input for security
# read -rs MYSQL_PASSWORD

# Prompt the user to select the database name
echo "Select the database to use:"
select MYSQL_DB_NAME in acore_world acore_auth acore_characters; do
    if [ -n "$MYSQL_DB_NAME" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Prompt the user to select the sql files folder
echo "Select the sql files directory to use:"
select SQL_FILES_DIRECTORY in /home/slayo/docker/wow-vanilla/modules/ /home/slayo/docker/wow-x10/modules/; do
    if [ -n "$SQL_FILES_DIRECTORY" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Search for 'sql' subdirectories containing SQL files and prompt the user to select one
echo "Select the directory containing SQL files:"
sql_directories=$(find $SQL_FILES_DIRECTORY -type d -name 'sql' -exec bash -c 'shopt -s globstar; for dir in "$1"/**; do if [[ -d "$dir" && ! -z $(find "$dir" -maxdepth 1 -type f -not -name ".gitkeep" -print -quit) ]]; then echo "$dir"; fi; done;' _ {} \;)
select sql_directory in $sql_directories; do
    if [ -n "$sql_directory" ]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Sort SQL files in alphabetical order
sql_files_sorted=$(ls "${sql_directory}"/*.sql | sort)

# Loop through each sorted SQL file
for sql_file in $sql_files_sorted; do
  if [ -e "$sql_file" ]; then
    # Import the SQL file into the database
    docker exec -i "$CONTAINER_NAME" mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DB_NAME" < "$sql_file"

    echo "Imported: $sql_file"
  fi
done
