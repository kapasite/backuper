#! /bin/sh
DIR=/root/backup #Editable
DAY=$(date +"%m.%d.%Y")
export TERM=${TERM:-dumb}
clear
echo ""
echo "--------------------------------"
echo "     CentminMod Backuper        "
echo "      omergorur@msn.com         "
echo "--------------------------------"
echo ""

echo -n "Enter domain name (without www. prefix): "
read SITE

if [ -z "${SITE}" ]; then
  echo "[Error]: $(tput setaf 1)Please enter a domain name.$(tput sgr0)"
  exit 1
fi

if [ ! -d "/home/nginx/domains/$SITE/" ]; then
 echo "[Error] : $(tput setaf 1)There is no such domain on the server.$(tput sgr0)"
 exit 1
fi

echo -n "Enter database name (db_name): "
read DB1

if [ -z "${DB1}" ]; then
  echo "[Error]: $(tput setaf 1)Please enter database name.$(tput sgr0)"
  exit 1
fi

if [ ! -d "/var/lib/mysql/$DB1" ]; then
  echo "[Error] : $(tput setaf 1)$DB1 database not found.$(tput sgr0)"
  exit 1
fi

#If another database

#Second database
read -ep "Do you have another database for this domain? [Y/n]: " second

if [[ "$second" = [yY] ]]; then
  echo -n "Enter database name (db_name): "
  read DB2
   if [ -z "${DB2}" ]; then
     echo "[Error]: $(tput setaf 1)Please enter database name.$(tput sgr0)"
     exit 1
   fi

   if [ ! -d "/var/lib/mysql/$DB2" ]; then
     echo "[Error] : $(tput setaf 1)$DB2 database not found.$(tput sgr0)"
     exit 1
   fi

    #Third database
    read -ep "Do you have another database for this domain? [Y/n]: " third

    if [[ "$third" = [yY] ]]; then
      echo -n "Enter database name (db_name): "
      read DB3
       if [ -z "${DB3}" ]; then
        echo "[Error]: $(tput setaf 1)Please enter database name.$(tput sgr0)"
        exit 1
       fi

       if [ ! -d "/var/lib/mysql/$DB3" ]; then
        echo "[Error] : $(tput setaf 1)$DB3 database not found.$(tput sgr0)"
        exit 1
       fi
    fi #
    fi
#

mkdir -p $DIR/$SITE/
cd $DIR/$SITE/
mysqldump --defaults-extra-file="/root/.my.cnf" $DB1 > /home/nginx/domains/$SITE/backup/$DB1.sql
sleep 3
if [[ "$second" = [yY] ]]; then
  mysqldump --defaults-extra-file="/root/.my.cnf" $DB2 > /home/nginx/domains/$SITE/backup/$DB2.sql
  sleep 3
fi
if [[ "$third" = [yY] ]]; then
  mysqldump --defaults-extra-file="/root/.my.cnf" $DB3 > /home/nginx/domains/$SITE/backup/$DB3.sql
  sleep 3
fi
echo ""
echo "----------------------------------"
echo "  The database has been exported  "
echo "----------------------------------"
ls -ltrh /home/nginx/domains/$SITE/backup/
tar cvzf $SITE-$DAY.tar.gz /home/nginx/domains/$SITE &> /dev/null
echo ""
echo "--------------------------------"
echo "  $(tput setaf 2)Backup completed$(tput sgr0)   "
echo "--------------------------------"
ls -ltrh
echo ""
echo "Backup directory : $(tput setaf 6)$DIR/$SITE$(tput sgr0)"
echo "Backup file name : $(tput setaf 3)$SITE-$DAY.tar.gz$(tput sgr0)"
rm -rf /home/nginx/domains/$SITE/backup/*.sql
sleep 2
echo ""
