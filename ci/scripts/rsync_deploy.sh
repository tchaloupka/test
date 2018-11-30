#!/bin/sh

# Načtení keyval hodnot do systémových proměnných
props="keyval/keyval.properties"
if [ -f "$props" ]; then
  echo "Reading passed key values"
  while IFS= read -r var
  do
    if [ ! -z "$var" ]; then
      echo "Adding: $var"
      export "$var"
    fi
  done < "$props"
else
  echo "No passed key values"
fi

# Kontrola parametrů
if ! [ -n "$PKEY_FILE" ]; then echo "Missing PKEY_FILE parameter"; return 1; fi
if ! [ -n "$FROM_DIR" ]; then echo "Missing FROM_DIR parameter"; return 1; fi
if ! [ -n "$TO_DIR" ]; then echo "Missing TO_DIR parameter"; return 1; fi

chmod 400 $PKEY_FILE # set correct PK file permissions

# Zajištění existence cílových podadresářů
if echo "$TO_DIR" | grep -Eq '.*@.*:/.*'; then
	if [ -n "$version" ]; then TO_DIR="$TO_DIR$version"; fi # přidání verze k cílovému adresáři
	echo "Ensuring SSH target parent path"
	ssh -v -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $PKEY_FILE ${TO_DIR%%:*} mkdir -p ${TO_DIR#*:}
else
	if [ -n "$version" ]; then FROM_DIR="$FROM_DIR$version"; fi # přidání verze k zdrojovému adresáři
	echo "Ensuring target parent path"
	mkdir -p $TO_DIR
fi

# samotná synchronizace do cíle
if [ "$NODEL" = "true" ]; then
  rsync -Pav -e 'ssh -v -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i '"$PKEY_FILE"'' $FROM_DIR $TO_DIR
else
  rsync -Pav --del -e 'ssh -v -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i '"$PKEY_FILE"'' $FROM_DIR $TO_DIR
fi
