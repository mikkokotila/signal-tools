#!/bin/bash

## r e q u i r e m e n t s 
# sudo apt-get install num-utils

user_agent()
{
	USER_AGENT=$(shuf website.ua | head -1) 
}

proxy()
{
	PROXY=$(shuf website.proxy | head -1)
}

alexa_data()
{
	wget --user-agent="$USER_AGENT" http://www.alexa.com/siteinfo/"$DOMAINs" -q --proxy-user "username" --proxy-password "password" use_proxy=yes -e http_proxy="$PROXY" -T 15 --tries=3

}


wot_data()
{
	curl https://www.mywot.com/en/scorecard/"$DOMAINs" -s -m 15 --retry 3 > wotdata
}


randomwait()
{
	seq 0.9 0.001 1.5 | shuf | head -1
}



alexa_branded()
{
	FORGREP1=$(echo $DOMAIN | cut -d '.' -f1)
	FORGREP2=$(grep -e "topkeywordellipsis" $DOMAINs | cut -d '=' -f3 | cut -d '>' -f1 | sed 's/^.//' | sed 's/.$//' | grep "$FORGREP");
	if [[ ! -z $FORGREP2 ]]
	then 
		echo "true";
	else
		echo "false";
	fi;
}


alexa_topcountries()
{
	grep -e "{title:" $DOMAINs | cut -d ':' -f3- | cut -d '"' -f1 | numsum
}

alexa_bouncerate()
{
	grep -e "%  " $DOMAINs | colrm 10 | tr -d ":[[:blank:]]:" | head -1
}

alexa_searchvisits()
{
	grep -e "%  " $DOMAINs | colrm 10 | tr -d ":[[:blank:]]:" | tail -1
}

alexa_rank()
{
	grep -e "  </strong>" $DOMAINs | colrm 15 | tr -d ":[[:blank:]]:" | sed 's/,//g' | head -1
}


alexa_pageviews()
{
	grep -e "  </strong>" $DOMAINs | colrm 15 | tr -d ":[[:blank:]]:" | head -4 | tail -1
}

alexa_timeonsite()
{
	grep -e "  </strong>" $DOMAINs | colrm 15 | tr -d ":[[:blank:]]:" | head -5 | tail -1
}

alexa_topkeywords()
{
	grep -e "topkeywordellipsis" $DOMAINs | cut -d '>' -f9 | cut -d '<' -f1 | numsum
}

alexa_inlinks()
{
	grep "font-4 box1-r" $DOMAINs | cut -d '>' -f2 | cut -d '<' -f1 | sed 's/,//g'
}

alexa_loadspeed()
{
	grep "loadspeed-panel-content" $DOMAINs | cut -d '(' -f2 | cut -d ')' -f1 | sed 's/[a-z]//g' | sed 's/\ S//'
}

alexa_males()
{
	grep "Males are" $DOMAINs | cut -d '>' -f3 | cut -d '<' -f1 | sed 's/-represented//'
}

alexa_females()
{
	grep "Females are" $DOMAINs | cut -d '>' -f3 | cut -d '<' -f1 | sed 's/-represented//'
}

wot_trust()
{
	grep "trustworthiness" wotdata | tr ' ' '\n' | grep data-value | cut -d '"' -f2
}

wot_childsafety()
{
	grep "childsafety" wotdata | tr ' ' '\n' | grep data-value | tr '"' '\n' | grep ^[0-9]
}


wot_spam()
{
	WOT_SPAM1=$(grep "core-board-category" wotdata | tr '>' '\n' | grep -e "^Spam")
	if [[ ! -z $WOT_SPAM ]]
	then 
		echo "true";
	else
		echo "false";
	fi;
}

wot_suspicious()
{
	WOT_SUSPICIOUS1=$(grep "core-board-category" wotdata | tr '>' '\n' | grep -e "^Suspicious")
        if [[ ! -z $WOT_SUSPICIOUS1 ]]
	then 
		echo "true";
	else
		echo "false";
	fi;
}

wot_adult()
{
	WOT_ADULT1=$(grep "core-board-category" wotdata | tr '>' '\n' | grep -e "^Adult")
        if [[ ! -z $WOT_ADULT1 ]]
	then 
		echo "true";
	else
		echo "false";
	fi;
}

wot_votes()
{
	grep -e "span itemprop=" wotdata | grep votes | cut -d '>' -f2 | cut -d '<' -f1
}



## p r o g r a m   s t a r t s

while read DOMAINs
do
	user_agent
	proxy
	alexa_data
	wot_data

	ALEXA_BRANDED=$(alexa_branded)
	ALEXA_RANK=$(alexa_rank)
	ALEXA_TOPCOUNTRIES=$(alexa_topcountries)
	ALEXA_BOUNCERATE=$(alexa_bouncerate)
	ALEXA_SEARCHVISITS=$(alexa_searchvisits)
	ALEXA_PAGEVIEWS=$(alexa_pageviews)
	ALEXA_TIMEONSITE=$(alexa_timeonsite)
	ALEXA_TOPKEYWORDS=$(alexa_topkeywords)
	ALEXA_INLINKS=$(alexa_inlinks)
	ALEXA_LOADSPEED=$(alexa_loadspeed)
	ALEXA_MALES=$(alexa_males)
	ALEXA_FEMALES=$(alexa_females)
	WOT_TRUST=$(wot_trust)
	WOT_CHILDSAFETY=$(wot_childsafety)
	WOT_SPAM=$(wot_spam)
	WOT_SUSPICIOUS=$(wot_suspicious)
	WOT_ADULT=$(wot_adult)
	WOT_VOTES=$(wot_votes)

	echo -e "$DOMAINs,$ALEXA_RANK,$ALEXA_INLINKS,$ALEXA_BRANDED,$WOT_SUSPICIOUS,$WOT_VOTES,$WOT_SPAM,$WOT_TRUST,$WOT_ADULT,$WOT_CHILDSAFETY,$ALEXA_BOUNCERATE,$ALEXA_SEARCHVISITS,$ALEXA_FEMALES,$ALEXA_MALES,$ALEXA_TOPKEYWORDS,$ALEXA_TOPCOUNTRIES,$ALEXA_TIMEONSITE,$ALEXA_PAGEVIEWS" >> signal.log
	rm "$DOMAINs"

	SLEEPTIME=$(randomwait)
	sleep "$SLEEPTIME"

 done <website.input
