#!/bin/sh
#
# This script builds cal.com docker image. Steps for building image are roughly
# described here: https://github.com/calcom/docker. If script breaks cross check
# steps from linked repository. Note that this script is expected to break in
# the future as build instruction for cal.com change. Also check for new/changed
# environment variables.
# 
# Usage:
# $ CAL_GITREF=v2.0.0 \
#   CAL_WEBURL=https://cal.example.com \
#   CAL_ENCRYPTION_KEY=xyz \
#   NEXT_ENCRYPTION_KEY=xyz \
#   DOCKER_REMOTE=ghcr.io/user/container \
#   ./build-calcom-image.sh
#
# Maintainers:
# - Bartol Deak <bartol@dump.hr>
# - Duje Šarić <dujes@dump.hr>

set -e
err() { echo "$0: $2" 1>&2; exit "$1"; }
tmp=$(mktemp -d)
trap "cleanup >/dev/null" EXIT

cleanup() {
	rm -rf "$tmp"
	docker rm -f calcom-postgres
}

# check dependencies
command -v git >/dev/null || err 1 "git required"
command -v docker >/dev/null || err 1 "docker required"

# check environment variables
test -n "$CAL_GITREF" || err 2 "\$CAL_GITREF required (calcom/calcom repository git ref to checkout)"
test -n "$CAL_WEBURL" || err 2 "\$CAL_WEBURL required (cal public url, example: https://cal.example.com)"
test -n "$CAL_ENCRYPTION_KEY" || err 2 "\$CAL_ENCRYPTION_KEY required (generate new with \"openssl rand -base64 32\")"
test -n "$NEXT_ENCRYPTION_KEY" || err 2 "\$NEXT_ENCRYPTION_KEY required (generate new with \"openssl rand -base64 32\")"
test -n "$DOCKER_REMOTE" || err 2 "\$DOCKER_REMOTE required (docker remote url, example: ghcr.io/user/container)"

# clone repository
gitrepo="$tmp/calcom-docker"
git clone https://github.com/calcom/docker "$gitrepo"
cd "$gitrepo"
git submodule update --remote --init
git -C calcom checkout "$CAL_GITREF"

# build docker image
docker run -d -e POSTGRES_USER=cal -e POSTGRES_PASSWORD=cal \
	--name calcom-postgres -p 5432:5432 postgres
docker build . -t "$DOCKER_REMOTE:$CAL_GITREF" --network host \
	--build-arg NEXT_PUBLIC_WEBAPP_URL="$CAL_WEBURL" \
	--build-arg NEXT_PUBLIC_LICENSE_CONSENT=agree \
	--build-arg CALCOM_TELEMETRY_DISABLED=1 \
	--build-arg NEXTAUTH_SECRET="$NEXT_ENCRYPTION_KEY" \
	--build-arg CALENDSO_ENCRYPTION_KEY="$CAL_ENCRYPTION_KEY" \
	--build-arg DATABASE_URL="postgresql://cal:cal@localhost:5432/cal"

# next steps
echo "Cal.com image build was successful. Upload it to container registry with:"
echo "$ docker push $DOCKER_REMOTE:$CAL_GITREF"

cd - >/dev/null
