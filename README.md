# Netlify helper tools to setup a Netlify page easily

## Get site list and ids

```bash
netlify sites:list
```

## Hooks

```bash
./scripts/upsert-hooks.sh -s="<site_id>" -d="$(cat ./json/hooks/email-notifications.json)" --dry-run

# The --upsert flag uses the "type" and "event" property to determine of the event exists already and update it if needed
./scripts/upsert-hooks.sh -s="<site_id>" -d="$(cat ./json/hooks/email-notifications.json)" --upsert
```

## Snippets

```bash
./scripts/upsert-snippets.sh -s="<site_id>" -d="$(cat ./json/snippets/browserupgrade.json)" --dry-run

# The --upsert flag uses the "title" property to determine of the event exists already and update it if needed
./scripts/upsert-snippets.sh -s="<site_id>" -d="$(cat ./json/snippets/browserupgrade.json)" --upsert
```