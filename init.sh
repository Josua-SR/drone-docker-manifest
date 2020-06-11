#!/bin/bash
#
# Copyright 2020 Josua Mayer <josua@solid-run.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing
# permissions and limitations under the License.
#

# environment settings
: ${PLUGIN_USERNAME:=}
: ${PLUGIN_PASSWORD:=}
: ${PLUGIN_PLATFORMS:=}
: ${PLUGIN_TARGET:=}
: ${PLUGIN_TEMPLATE:=}
: ${PLUGIN_TAGS:=}

# check required arguments
if ( [ -z "$PLUGIN_USERNAME" ] && [ -n "$PLUGIN_PASSWORD" ] ) || ( [ -n "$PLUGIN_USERNAME" ] && [ -z "$PLUGIN_PASSWORD" ] ); then
	echo "Require both - or none of username and password!"
	exit 1
fi

if [ -z "$PLUGIN_PLATFORMS" ]; then
	echo "Require platforms!"
	exit 1
fi

if [ -z "$PLUGIN_TARGET" ]; then
	echo "Require target!"
	exit 1
fi

if [ -z "$PLUGIN_TEMPLATE" ]; then
	echo "Require template!"
	exit 1
fi

if [ -z "$PLUGIN_TAGS" ]; then
	echo "Require at least one tag!"
	exit 1
fi

# tag substitution in template with first tag
tag=`echo $PLUGIN_TAGS | cut -d, -f1`
template=${PLUGIN_TEMPLATE//TAG/$tag}

# invoke manifest-tool
IFS=,; for tag in $PLUGIN_TAGS; do
	target="$PLUGIN_TARGET:$tag"

	echo manifest-tool --username "hidden" --password "hidden" push from-args --platforms "$PLUGIN_PLATFORMS" --target "$target" --template "$template"
	manifest-tool --username "$PLUGIN_USERNAME" --password "$PLUGIN_PASSWORD" push from-args --platforms "$PLUGIN_PLATFORMS" --target "$target" --template "$template"
done

exit $?
