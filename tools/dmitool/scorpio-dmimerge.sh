#!/usr/bin/env bash
# scorpio-dmimerge.sh
# Copyright 2020-2021 Patrick Meade
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#-----------------------------------------------------------------------------

# From the root of the project, invoke it like this:
# tools/dmitool/scorpio-dmimerge.sh icons/mob/head.dmi

ICON_PATH="$1"
ICON_FILE=$(basename $ICON_PATH)
ICON_ANCESTOR="/tmp/$ICON_FILE.1"
ICON_OURS="/tmp/$ICON_FILE.2"
ICON_THEIRS="/tmp/$ICON_FILE.3"
ICON_MERGED="/tmp/$ICON_FILE"

git show :1:$ICON_PATH > "$ICON_ANCESTOR"
git show :2:$ICON_PATH > "$ICON_OURS"
git show :3:$ICON_PATH > "$ICON_THEIRS"

if java -jar tools/dmitool/dmitool.jar merge $ICON_ANCESTOR $ICON_OURS $ICON_THEIRS $ICON_MERGED
then
    echo "Icon successfully merged to ${ICON_MERGED}"
    echo "cp -v ${ICON_MERGED} ${ICON_PATH}"
    cp -v "${ICON_MERGED}" "${ICON_PATH}"
    echo "git add ${ICON_PATH}"
    git add "${ICON_PATH}"
else
    echo "Unable to resolve conflicts in ${ICON_PATH}"
    exit 1
fi

#-----------------------------------------------------------------------------
# end of scorpio-dmimerge.sh
