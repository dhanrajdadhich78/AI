#!/bin/bash
set -e

if [[ $CIRCLE_BRANCH != pull* ]]
then
	git config --global user.name "the-dagger"
	git config --global user.email "harshithdwivedi@gmail.com"

	git clone --quiet --branch=apk https://the-dagger:$GITHUB_API_KEY@github.com/fossasia/susi_android apk > /dev/null
	ls
	cp -r ${HOME}/${CIRCLE_PROJECT_REPONAME}/app/build/outputs/apk/app-debug.apk apk/susi-debug.apk
	cp -r ${HOME}/${CIRCLE_PROJECT_REPONAME}/app/build/outputs/apk/app-release-unsigned.apk apk/susi-release.apk
	cd apk

	git checkout --orphan workaround
	git add -A

	git commit -am "[Circle CI] Update Susi Apk"

	git branch -D apk
	git branch -m apk

	git push origin apk --force --quiet > /dev/null

	curl https://$APPETIZE_API_TOKEN@api.appetize.io/v1/apps/mbpprq4xj92c119j7nxdhttjm0 -H 'Content-Type: application/json' -d '{"url":"https://github.com/fossasia/susi_android/raw/apk/susi-debug.apk", "note": "Update SUSI Preview"}'
fi

