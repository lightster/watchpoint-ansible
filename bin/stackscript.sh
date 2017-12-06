#!/bin/bash
#
#<UDF name="keeper_password" label="Password for keeper">

# copy stdout and stderr to a log file
exec > >(tee -a /var/log/stackscript.log) 2>&1

set -e
set -u
set -x

KEEPER_USERNAME="boxkeeper"
KEEPER_HOMEDIR="/home/${KEEPER_USERNAME}"
KEEPER_SSHDIR="${KEEPER_HOMEDIR}/.ssh"
KEEPER_KEYS="${KEEPER_SSHDIR}/authorized_keys"

if id -u "${KEEPER_USERNAME}" >/dev/null 2>&1 ; then
    echo -n "User '${KEEPER_USERNAME}' already exists... skipping"
else
    echo -n "Creating '${KEEPER_USERNAME}' user..."
    useradd --create-home --groups sudo --shell /bin/bash ${KEEPER_USERNAME}
fi

if [ ! -z ${KEEPER_PASSWORD:+x} ]; then
    # disable command tracing
    set +x
    echo "${KEEPER_USERNAME}:${KEEPER_PASSWORD}" | chpasswd
    # re-enable tracing
    set -x
fi

echo "%${KEEPER_USERNAME} ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/${KEEPER_USERNAME}
echo " done"

mkdir -p ${KEEPER_SSHDIR}
chmod 0700 ${KEEPER_SSHDIR}
touch ${KEEPER_KEYS}
chmod 0600 ${KEEPER_KEYS}
curl -sS https://github.com/lightster.keys > ${KEEPER_KEYS}
curl -sS https://github.com/zacharyrankin.keys >> ${KEEPER_KEYS}
chown -R ${KEEPER_USERNAME}:${KEEPER_USERNAME} ${KEEPER_SSHDIR}
