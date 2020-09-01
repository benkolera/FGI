#!/usr/bin/env bash
THIS_DIR=$(pwd)/$(dirname $0)
RULESETS=(DORCoreMin)
EXTENSIONS=(MJB_DOCEHelloWorld)

cd $THIS_DIR

if [[ -f ".deployrc" ]]; then
	source ".deployrc"
else
	echo "Warning: $THIS_DIR/.deployrc does not exist. Create one by copying from .deployrc.sample and changing the path to FG."
fi


if [[ -z $FG_DATA_DIR ]]; then
	echo "Error: Please set FG_DATA_DIR in .deployrc"
	exit
elif [[ ! -d "$FG_DATA_DIR" ]]; then
  echo "Error: $FG_DATA_DIR does not exist"
  exit 
fi

for r in ${RULESETS[@]}; do
	path=$THIS_DIR/$r
  if [[ -d $path ]]; then
		rsync -rP $path "$FG_DATA_DIR/rulesets"
  else
	  echo "Warning: Ruleset $path does not exist!"
	fi
done

for e in ${EXTENSIONS[@]}; do
	path=$THIS_DIR/$e
  if [[ -d $path ]]; then
		rsync -rP $path "$FG_DATA_DIR/extensions"
  else
	  echo "Warning: Extension $path does not exist!"
	fi
done

echo 
echo "------------------------------------------------------------------------"
echo "Deployed! You should be able to /reload in the fg chat to see your new"
echo "changes!"
echo "------------------------------------------------------------------------"