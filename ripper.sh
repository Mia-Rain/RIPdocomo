#!/bin/sh
# This ripper requires a pre-exising $YEAR/assests file
# Which can be generated as follows:
###
# curl -L https://emojipedia.org/docomo/$YEAR | sed -e '/emoji-grid/,$!d' -e '/lazymore/q' > ./$YEAR/assests
# cat $YEAR/assests | sed -e 's/<img.*src=/src=/g' -e 's/".data-srcset=.* alt=/" alt=/g' -e 's/".title.*>/"/g' | tr '\n' '~' | sed -e "s/<a.href=\"\/docomo\/$YEAR\//name=\"/g" -e 's/\/">~/" /g' | tr '~' '\n' > assests; mv ./assests > $YEAR/assests
# sed 's/alt=".*"//g' -i ./$YEAR/assests
# sed 's/srcset=".*"//g' -i ./$YEAR/assests
###
# One could generate an assests file for all years using a for loop (as I did)
### Being script
GITD=$(realpath ./)
for i in */; do # This will only RIP for existing $YEAR folders, _breaking_ if the assests file is missing
  grep "src" ./$i/assests > $i/g
  echo "Ripping Docomo verison $i"
  cd "$i"
  IFS=" "; while read -r name src; do
    if ! ls $GITD/$i/$(echo ${name#name=} | sed 's/"//g' )* 2>/dev/null 1>/dev/null ;then
      curl -L --progress-bar $(echo ${src#src=} | sed 's/"//g') --output $(echo ${name#name=} | sed 's/"//g')
    else 
      echo "${name#name=} already ripped"
    fi
  done < $GITD/$i/g
  rm $GITD/$i/g
  cd $GITD
done
