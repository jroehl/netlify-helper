# Netlify helper tools to setup a Netlify page easily

## Get site list and ids

```bash
netlify sites:list

netlify sites:list --json | jq -r '.[].site_id' | while read i; do ./scripts/upsert-hooks.sh -s="${i}" -d="$(cat ./json/hooks/email-notifications.json)" --upsert --dry-run; done
netlify sites:list --json | jq -r '.[].site_id' | while read i; do ./scripts/upsert-hooks.sh -s="${i}" -d="$(cat ./json/hooks/webhook-notifications.json)" --upsert --dry-run; done
```

## Hooks

```bash
./scripts/upsert-hooks.sh -s="<site_id>" -d="$(cat ./json/hooks/email-notifications.json)" --dry-run

# The --upsert flag uses the "type", "event" and "data" property to determine of the event exists already and update it if needed
./scripts/upsert-hooks.sh -s="<site_id>" -d="$(cat ./json/hooks/email-notifications.json)" --upsert

netlify sites:list --json | jq -r '.[].site_id' | while read i; do ./scripts/upsert-hooks.sh -s="${i}" -d="$(cat ./json/hooks/email-notifications.json)" --upsert --dry-run; done

netlify sites:list --json | jq -r '.[].site_id' | while read i; do ./scripts/upsert-hooks.sh -s="${i}" -d="$(cat ./json/hooks/webhook-notifications.json)" --upsert --dry-run; done
```

## Snippets

```bash
./scripts/upsert-snippets.sh -s="<site_id>" -d="$(cat ./json/snippets/browserupgrade.json)" --dry-run

# The --upsert flag uses the "title" property to determine of the event exists already and update it if needed
./scripts/upsert-snippets.sh -s="<site_id>" -d="$(cat ./json/snippets/browserupgrade.json)" --upsert

netlify sites:list --json | jq -r '.[].site_id' | while read i; do ./scripts/upsert-snippets.sh -s="${i}" -d="$(cat ./json/snippets/browserupgrade.json)" --upsert --dry-run; done

netlify sites:list --json | jq -r '.[].site_id' | while read i; do ./scripts/upsert-snippets.sh -s="${i}" -d="$(cat ./json/snippets/browserupgrade.json)" --upsert --dry-run; done
```
