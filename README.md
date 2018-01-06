# watchpoint-ansible

Setup and manage servers within the Watchpoint infrastructure.

## Installation

1. Clone the repo to your personal workspace (localhost or whatnot)

2. Install Ansible 2.4.2.0+:
```bash
brew install ansible
```

3. Create a file called `.vault_pass` containing our vault password

4. Run
```bash
./configure production
```

## Releasing watchpoint-pickem

Run:

```bash
make release
```
